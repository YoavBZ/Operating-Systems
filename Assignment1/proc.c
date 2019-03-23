#include "schedulinginterface.h"
#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

extern PriorityQueue pq;
extern RoundRobinQueue rrq;
extern RunningProcessesHolder rpholder;


struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;


long long getAccumulator(struct proc *p) {
  return p->accumulator;
}

static struct proc *initproc;

int nextpid = 1;
int currPolicy = PRIORITY;
int quantumTime = 0;

void
minimizeProcAcc(struct proc *np)
{
  long long accRunnable;
  long long accRunning;
  boolean gotPqMin = pq.getMinAccumulator(&accRunnable);
  boolean gotRpholdetMin = rpholder.getMinAccumulator(&accRunning);
  if (!gotPqMin && !gotRpholdetMin){
    np->accumulator = 0;
  }
  else if (!gotPqMin && gotRpholdetMin){
    np->accumulator = accRunning;
  }
  else if (gotPqMin && !gotRpholdetMin){
    np->accumulator = accRunnable;
  }
  else{
    np->accumulator = (accRunning > accRunnable) ? accRunnable : accRunning;
  }
};

void
handleStateChange(struct proc *p, int nState){
  // Removing process from RunningProcessesHolder queue if state is changed from RUNNING
  if(p->state == RUNNING && !rpholder.remove(p)){
    panic("Couldn't remove process from rpholder!");
  }

  switch (currPolicy){
    case ROUND_ROBIN:
      switch (nState){
        case EMBRYO:
          p->state = EMBRYO;
          p->priority = 5;
          p->accumulator = 0;
          p->pid = nextpid++;
          p->waitingTime = 0;
          break;

        case RUNNABLE:
          p->state = RUNNABLE;
          rrq.enqueue(p);
          break;

        case RUNNING:
          p->state = RUNNING;
          break;
      }
      break;

    case PRIORITY:
      switch (nState){
        case EMBRYO:
          p->state = EMBRYO;
          p->priority = 5;
          minimizeProcAcc(p);
          p->pid = nextpid++;
          p->waitingTime = 0;
          break;
          
        case RUNNABLE:
          if (p->state == SLEEPING){
            // Minimizing the process accumulator if switched from SLEEPING to RUNNABLE
            minimizeProcAcc(p);
          } 
          if (p->state == RUNNING){
            p->accumulator += p->priority;
          }
          if(!pq.put(p)){
            panic("Couldn't add process to pq!");
          }
          p->state = RUNNABLE;
          break;

        case RUNNING:
          p->state = RUNNING;
          break;
      }
  }

  // Adding process to RunningProcessesHolder queue if state was changed to RUNNING
  if (nState == RUNNING && !rpholder.add(p)){
    panic("Couldn't add process to rpholder!");
  }
}

extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

  found:
    handleStateChange(p, EMBRYO);
    
    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
      p->state = UNUSED;
      return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
    p->tf = (struct trapframe*)sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
  // p->accumulator = 0;
  // p->priority = 5;
  // p->waitingTime = 0;
  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  handleStateChange(p, RUNNABLE);
  // p->state = RUNNABLE;
  // if(currPolicy == ROUND_ROBIN){
  //   if(!rrq.enqueue(p)){
  //     panic("add to rrq has a problem, function:userinit");
  //   }
  // }
  // else{
  //   if(!pq.put(p)){
  //     panic("add to pq has a problem, function:userinit");
  //   }
  // }

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);

  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);
    
  handleStateChange(np, RUNNABLE);
  // np->priority = 5;
  // np->waitingTime = 0;

  // long long * accRunnable = null;
  // long long * accRunning = null;
  // boolean gotPqMin = pq.getMinAccumulator(accRunnable);
  // boolean gotRpholdetMin = rpholder.getMinAccumulator(accRunning);
  // if(!gotPqMin && !gotRpholdetMin){
  //   np->accumulator = 0;
  // }
  // if(!gotPqMin && gotRpholdetMin ){
  //   np->accumulator = *accRunning;
  // }
  // if(gotPqMin && !gotRpholdetMin ){
  //   np->accumulator = *accRunnable;
  // }
  // else{
  //   np->accumulator = (*accRunning > *accRunnable) ? *accRunnable : *accRunning ;
  // }

  // if(currPolicy == ROUND_ROBIN){
  //   if(!rrq.enqueue(np)){
  //     panic("add to rrq has a problem, function:fork");
  //   }
  // }
  // else{
  //   if(!pq.put(np)){
  //     panic("add to pq has a problem, function:fork");
  //   }
  // }

  release(&ptable.lock);
  return pid;
}

int
detach(int pid){
  struct proc *curproc = myproc(), *p;
  int returnValue = -1;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid ){
      if(p->parent == curproc){
        p->parent = initproc;
        if (p->state == ZOMBIE){
          wakeup1(initproc);
        }
        returnValue = 0;
      }
      break;
    }
  }
  release(&ptable.lock);
  return returnValue;
}

// Changes current policy to the given policy:
// 1 - Round Robin, 2 - Priority, 3 - Extended Priority
void
policy(int policy){ 
    struct proc * p;
  if(policy < 1 || policy > 3){
    panic("bad policy choise");
  }
  acquire(&ptable.lock);
  if(policy == ROUND_ROBIN){
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      p->accumulator = 0;
    }
    pq.switchToRoundRobinPolicy();
  }
  else if(policy == PRIORITY){
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->priority == 0){
        p->priority = 1;
      }
    }
    rrq.switchToPriorityQueuePolicy();
  }
  else{
    rrq.switchToPriorityQueuePolicy();
  }
  currPolicy = policy;
  release(&ptable.lock);
  
}

void
priority(int priority){
  struct proc *curproc = myproc();
  if(currPolicy != PRIORITY){
    if(priority < 1 || priority > 10){
      panic ("bad priority");
    }
  }
  else{
     if(priority < 0 || priority > 10){
      panic ("bad priority");
    }

  }
  acquire(&ptable.lock);
  curproc->priority = priority;
  release(&ptable.lock);
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(int status)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;
  curproc->exitStatus = status;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  // if(curproc->state == RUNNING){
  //   if(!rpholder.remove(p)){
  //    panic("remove from rpholder has a problem, function:exit");
  //   }
  // }
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");

}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(int* status)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        // updating status to the exit status of the child.
        if(status != null){
          *status = p->exitStatus;
        }
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
      if(!havekids || curproc->killed){
        release(&ptable.lock);
        return -1;
      }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}


// This func return the proc that waiting for the longest time , ptable is acquired while calling 
struct proc *
getMaxWaitingTime (){
  struct proc *maxProc = null;
  long long maxValue = 0;
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->waitingTime > maxValue){
      maxProc = p;
      maxValue = p->waitingTime;
    }
  }
  return maxProc;
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p = null;
  struct cpu *c = mycpu();
  c->proc = 0;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    acquire(&ptable.lock);
    /* scheduler change is here */
    switch(currPolicy){
      case ROUND_ROBIN :
        p = rrq.dequeue();
        break;
      case PRIORITY:
         p = pq.extractMin();
        break;
      case EXTENDED_PRIORITY:
        if(quantumTime >= 100){
          quantumTime = 0;
          p = getMaxWaitingTime();
          pq.extractProc(p);
        }
        else{
          p = pq.extractMin();
        }
         if(!pq.extractProc(p)){
            panic("remove from pq has a problem, function:scheduler");
          }
        break;
    }
    
    if(p != null){
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      handleStateChange(p, RUNNING);

      swtch(&(c->scheduler), p->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
  }
}


// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  struct proc *p = myproc();
  // struct proc * runnerProc ;

  // quantumTime ++;
  // for(runnerProc= ptable.proc; runnerProc < &ptable.proc[NPROC]; runnerProc++){
  //   if(runnerProc != p){
  //     runnerProc->waitingTime ++ ;
  //   }
  // }

  handleStateChange(p, RUNNABLE);
  // p->state = RUNNABLE;
  // p->waitingTime = 0;
  // p->accumulator += p->priority;
  
  // cprintf("remove now \n");
  // if(!rpholder.remove(p)){
  //   panic("remove from rpholder has a problem, function:yield");
  // }
  // if(currPolicy == ROUND_ROBIN){
  //   if(!rrq.enqueue(p)){
  //     panic("add to rrq has a problem, function:yield");
  //   }
  // }
  // else{
  //   if(!pq.put(p)){
  //     panic("add to pq has a problem, function:yield");
  //   }
  // }

  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  // if(p->state == RUNNING && !rpholder.remove(p)){
  //   panic("remove from rpholder has a problem, function:sleep");
  // }

  // if(p->state == RUNNABLE && currPolicy == ROUND_ROBIN && !rrq.dequeue()){
  //   panic("remove from rrq has a problem, function:sleep");
  // }

  // if(p->state == RUNNABLE && currPolicy !=ROUND_ROBIN && !pq.extractProc(p)){
  //   panic("remove from pq has a problem, function:sleep");
  // }

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan){
      // long long * accRunnable = null;
      // long long * accRunning = null;
      // boolean gotPqMin = pq.getMinAccumulator(accRunnable);
      // boolean gotRpholdetMin = rpholder.getMinAccumulator(accRunning);
      // if(!gotPqMin && !gotRpholdetMin){
      //   p->accumulator = 0;
      // }
      // if(!gotPqMin && gotRpholdetMin ){
      //   p->accumulator = *accRunning;
      // }
      // if(gotPqMin && !gotRpholdetMin ){
      //   p->accumulator = *accRunnable;
      // }
      // else{
      //   p->accumulator = (*accRunning > *accRunnable) ? *accRunning : *accRunnable ;
      // }
      // p->state = RUNNABLE;
      handleStateChange(p, RUNNABLE);
      // if(currPolicy){
      //   if(!rrq.enqueue(p)){
      //     panic("add to rrq has a problem, function:wakeup1");
      //   }
      // }
      // else{
      //   if(!pq.put(p)){
      //    panic("add to pq has a problem, function:wakeup1");
      //   }
      // }
   }
}

// Wake up all processes sleeping on chan.
  void
  wakeup(void *chan)
  {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
  }

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
  int
  kill(int pid)
  {
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pid == pid){
        p->killed = 1;
      // Wake process from sleep if necessary.
        if(p->state == SLEEPING){
          handleStateChange(p, RUNNABLE);
          // p->state = RUNNABLE;
          // if(currPolicy == ROUND_ROBIN){
          //   if(!rrq.enqueue(p)){
          //     panic("add to rrq has a problem,function:kill");
          //   }
          // }
          // else{
          //   if(!pq.put(p)){
          //     panic("add to rrq has a problem,function:kill");
          //   }
          // }
        }
        release(&ptable.lock);
        return 0;
      }
    }
    release(&ptable.lock);
    return -1;
  }

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
  void
  procdump(void)
  {
    static char *states[] = {
      [UNUSED]    "unused",
      [EMBRYO]    "embryo",
      [SLEEPING]  "sleep ",
      [RUNNABLE]  "runble",
      [RUNNING]   "run   ",
      [ZOMBIE]    "zombie"
    };
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state == UNUSED)
        continue;
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
        state = states[p->state];
      else
        state = "???";
      cprintf("%d %s %s", p->pid, state, p->name);
      if(p->state == SLEEPING){
        getcallerpcs((uint*)p->context->ebp+2, pc);
        for(i=0; i<10 && pc[i] != 0; i++)
          cprintf(" %p", pc[i]);
      }
      cprintf("\n");
    }
  }
