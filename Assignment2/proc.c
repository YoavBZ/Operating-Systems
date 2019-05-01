#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "kthread.h"
#include "tournament_tree.h"

struct {
    struct spinlock lock;
    struct proc proc[NPROC];
} ptable;

struct {
    struct spinlock lock;
    struct kthread_mutex_t mutexes[MAX_MUTEXES];
} mutex_table;


static struct proc *initproc;

int nextpid = 1;
int nexttid = 1;

extern void forkret(void);

extern void trapret(void);

static void wakeup1(void *chan);

int isLastThread(struct proc *p) {
    int isLast = 1;
    struct thread *curthread = mythread();
    acquire(&ptable.lock);
    for (struct thread *t = p->threads; t < &p->threads[NTHREADS]; t++) {
        if (t->tid != curthread->tid &&
            (t != curthread && t->state != UNUSED && t->state != ZOMBIE)) {
            isLast = 0;
        }
    }
    release(&ptable.lock);
    return isLast;
}

void
pinit(void) {
    initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
    return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
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

struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
    c = mycpu();
    t = c->thread;
    popcli();
    return t;
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct thread *t = mythread();
    if (!t) {
        return 0;
    }
    return t->proc;
}


//important note : assuming ptable.lock is hold
static struct thread *
allocthread(struct proc *p) {
    char *sp;
    struct thread *newThread = 0;
    //find place for the thread
    for (struct thread *t = p->threads; t < &p->threads[NTHREADS]; t++) {
        if (t->state == UNUSED) {
            newThread = t;
            break;
        }
    }
    if (!newThread) {
        return 0;
    }

    newThread->tid = nexttid++;
    newThread->state = EMBRYO;
    newThread->proc = p;

    // Allocate kernel stack.
    if ((newThread->kstack = kalloc()) == 0) {
        newThread->state = UNUSED;
        return 0;
    }
    sp = newThread->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *newThread->tf;
    newThread->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *newThread->context;
    newThread->context = (struct context *) sp;
    memset(newThread->context, 0, sizeof *newThread->context);
    newThread->context->eip = (uint) forkret;
    newThread->chan = 0;
    return newThread;
}

static struct proc *
allocproc(void) {
    struct proc *p;
    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED_P)
            goto found;

    release(&ptable.lock);
    return 0;

    found:
    p->pid = nextpid++;
    for (struct thread *t = p->threads; t < &p->threads[NTHREADS]; t++) {
        t->state = UNUSED;
        t->proc = p;
    }
    if (!allocthread(p)) {  //bad init
        release(&ptable.lock);
        return 0;
    }
    p->state = USED_P;
    release(&ptable.lock);
    return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];
    p = allocproc();
    struct thread *t = &p->threads[0];
    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(t->tf, 0, sizeof(*t->tf));
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    t->tf->es = t->tf->ds;
    t->tf->ss = t->tf->ds;
    t->tf->eflags = FL_IF;
    t->tf->esp = PGSIZE;
    t->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
    p->cwd = namei("/");


    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
    t->state = RUNNABLE;
    release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();

    acquire(&ptable.lock);
    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) {
            release(&ptable.lock);
            return -1;
        }
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0) {
            release(&ptable.lock);
            return -1;
        }
    }
    curproc->sz = sz;
    switchuvm(curthread);
    release(&ptable.lock);
    return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();

    if (mythread()->proc != curproc) {
        curproc = mythread()->proc;
    }

    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
    }
    acquire(&ptable.lock);
    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        for (struct thread *t = np->threads; t < &np->threads[NTHREADS]; t++) {
            kfree(t->kstack);
            t->kstack = 0;
            t->state = UNUSED;
        }
        np->state = UNUSED_P;
        release(&ptable.lock);
        return -1;
    }
    np->sz = curproc->sz;
    np->parent = curproc;
    struct thread *nt = &np->threads[0];
    *nt->tf = *mythread()->tf;

    // Clear %eax so that fork returns 0 in the child.
    nt->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));

    pid = np->pid;

    nt->state = RUNNABLE;
    np->state = USED_P;
    release(&ptable.lock);
    return pid;
}

// Last thread will execute this function and exit process . important note : no need to sync here - only one thread!
void
exitProcess() {
    struct proc *curproc = myproc();
    struct proc *p;
    int fd;

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }

    begin_op();
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;

    acquire(&ptable.lock);

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
            if (p->state == ZOMBIE_P) {
                wakeup1(initproc);
            }
        }
    }

    // Jump into the scheduler, never to return.
    mythread()->state = ZOMBIE;
    curproc->state = ZOMBIE_P;
    sched();
    panic("zombie exit");
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
    struct proc *curproc = myproc();

    if (curproc == initproc)
        panic("init exiting");

    acquire(&ptable.lock);
    if (!curproc->killed) {
        curproc->killed = 1;
    }

    mythread()->state = ZOMBIE;
    release(&ptable.lock);
    // Exit process if it's the last thread
    if (isLastThread(curproc)) {
        exitProcess();
    }
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE_P) {
                pid = p->pid;
                // Found one.
                for (struct thread *t = p->threads; t < &p->threads[NTHREADS]; t++) {
                    if (t->state != UNUSED) {
                        kfree(t->kstack);
                        t->kstack = 0;
                        t->pid = 0;
                        t->proc = 0;
                        t->state = UNUSED;
                    }
                }
                p->name[0] = 0;
                p->parent = 0;
                p->pid = 0;
                p->state = UNUSED_P;
                p->killed = 0;
                freevm(p->pgdir);
                release(&ptable.lock);
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
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
scheduler(void) {
    struct proc *p;
    struct cpu *c = mycpu();
    c->proc = 0;
    c->thread = 0;

    for (;;) {
        // Enable interrupts on this processor.
        sti();
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->state != USED_P) {
                continue;
            }
            for (struct thread *t = p->threads; t < &p->threads[NTHREADS]; t++) {
                if (t->state != RUNNABLE) {
                    continue;
                }

                // Switch to chosen thread.  It is the thread's job
                // to release ptable.lock and then reacquire it
                // before jumping back to us.
                c->proc = p;
                c->thread = t;
                switchuvm(t);
                t->state = RUNNING;

                swtch(&(c->scheduler), t->context);
                switchkvm();

                // Process is done running for now.
                // It should have changed its p->state before coming back.
                c->thread = 0;
            }
            c->proc = 0;
        }
        release(&ptable.lock);
    }
}

// Enter scheduler.  Must hold only ptable.lock + curr proc lock (only if more than one thread is running)
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
    int intena;
    struct thread *t = mythread();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    swtch(&t->context, mycpu()->scheduler);
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
    acquire(&ptable.lock);  //DOC: yieldlock
    mythread()->state = RUNNABLE;
    sched();
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
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
sleep(void *chan, struct spinlock *lk) {
    struct thread *t = mythread();
    struct proc *p = myproc();

    if (p == 0 || t == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");

    // Must acquire ptable.lock in order to
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }
    // Go to sleep.
    t->chan = chan;
    t->state = SLEEPING;

    sched();

    // Tidy up.
    t->chan = 0;
    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == USED_P) {
            for (struct thread *t = p->threads; t < &p->threads[NTHREADS]; t++) {
                if (t->state == SLEEPING && t->chan == chan)
                    t->state = RUNNABLE;
            }
        }
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
    struct proc *p;

    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
            // Wake threads from sleep if necessary.
            for (struct thread *t = p->threads; t < &p->threads[NTHREADS]; t++) {
                if (t->state == SLEEPING) {
                    t->state = RUNNABLE;
                }
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
procdump(void) {
    static char *threadstates[] = {
            [UNUSED]    "unused",
            [EMBRYO]    "embryo",
            [SLEEPING]  "sleep ",
            [RUNNABLE]  "runble",
            [RUNNING]   "run   ",
            [ZOMBIE]    "zombie"
    };
    static char *states[] = {
            [UNUSED_P]    "unused",
            [USED_P]      "used",
            [ZOMBIE_P]    "zombie",
            [TERMINATING_P] "terminating"
    };
    int i;
    struct proc *p;
    struct thread *t;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED_P)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        for (t = p->threads; t < &p->threads[NTHREADS]; t++) {
            if (t->state == UNUSED)
                continue;
            if (t->state >= 0 && t->state < NELEM(threadstates) && threadstates[t->state])
                state = threadstates[t->state];
            else
                state = "???";
            cprintf("tid : %d %s ", t->tid, state);
            if (t->state == SLEEPING) {
                getcallerpcs((uint *) t->context->ebp + 2, pc);
                for (i = 0; i < 10 && pc[i] != 0; i++)
                    cprintf(" %p", pc[i]);
            }
        }

        cprintf("\n");
    }
}

//ptable.lock must be held here!!!!
int finish_all_threads() {
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();

    for (struct thread *thread = curproc->threads; thread < &curproc->threads[NTHREADS]; thread++) {
        if (thread->tid == curthread->tid) //pass curr thread
            continue;
        if (thread->state != UNUSED) {
            return 0;
        }
    }
    return 1;
}


void stop_threads() {
    struct proc *curproc = myproc();
    if (!holding(&ptable.lock)) {
        acquire(&ptable.lock);
    }
    curproc->killed = 1; //kill the process, force threads to kill themself.

    while (!finish_all_threads()) { //wait for  threads to exit while curthread is here!
        sleep(curproc, &ptable.lock);
    }
    curproc->killed = 0;
    release(&ptable.lock);
}

s

int kthread_create(void (*start_func)(), void *stack) { // in case of fail return non positive value
    struct thread *runningThread = mythread();
    struct thread *newThread;
    struct proc *p = myproc();
    acquire(&ptable.lock);
    newThread = allocthread(p);
    if (0 == newThread) {
        release(&ptable.lock);
        return -1;
    }
    *newThread->tf = *runningThread->tf;
    newThread->tf->eip = (uint) start_func;
    newThread->tf->esp = (uint) stack;
    newThread->state = RUNNABLE;
    release(&ptable.lock);
    return newThread->tid;
}

int kthread_join(int thread_id) {
    struct proc *p = myproc();
    struct thread *t;
    if (mythread()->tid == thread_id) {
        return -1;
    }
    acquire(&ptable.lock);
    for (t = p->threads; t < &p->threads[NTHREADS]; t++) {
        if (t->tid == thread_id) {  //found
            while (t->state != UNUSED && t->state != ZOMBIE) {
                // TODO: Remove ZOMBIE??
                sleep(p, &ptable.lock); //first variable is chan, second is curr holding lock.
            }
            //if thread is zombie , change him to unused
            if (t->state == ZOMBIE) {
                kfree(t->kstack);
                t->kstack = 0;
                t->tid = 0;
                t->proc = 0;
                t->state = UNUSED;
            }
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock); //not found - bad thread_id should return non-positive value.
    return -1;
}

int
kthread_id() {
    return mythread()->tid;
}

void dealloc_thread_mutexes() {
    struct kthread_mutex_t *curmutex;
    int curtid = mythread()->tid;
    acquire(&mutex_table.lock);
    for (int i = 0; i < MAX_MUTEXES; i++) {
        curmutex = &mutex_table.mutexes[i];
        if (curmutex->tid == curtid) {
            if (holdingsleep(&curmutex->slock)) {
                releasesleep(&curmutex->slock);
            }
            curmutex->state = UNUSED_MUTEX;
            curmutex->tid = -1;

        }
    }
    release(&mutex_table.lock);
}


void kthread_exit() {
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();
    acquire(&ptable.lock);
    curthread->state = ZOMBIE;
    release(&ptable.lock);
    dealloc_thread_mutexes();
    if (isLastThread(curproc)) {
        exit();
    } else { //just release thread
        wakeup(curproc);
        acquire(&ptable.lock);
        sched();
        //should not be here.
        panic("kthread exit error");
    }
}

int check_mutex_id_range_and_mutex_used(int mutex_id) {
    if (mutex_id < 0 || mutex_id >= MAX_MUTEXES) {
        return 0;
    }
    if (!holding(&mutex_table.lock)) {
        panic("not holding mutex table!");
    }
    struct kthread_mutex_t curmutex = mutex_table.mutexes[mutex_id];
    if (curmutex.state != USED_MUTEX) {
        return 0;
    }
    return 1;
}

int
kthread_mutex_alloc() { //this func only alloc one of the mutexes to curr thread , change state to used and return mutex state id
    acquire(&mutex_table.lock);
    for (uint i = 0; i < MAX_MUTEXES; i++) {
        struct kthread_mutex_t *curmutex = &mutex_table.mutexes[i];
        if (curmutex->state == UNUSED_MUTEX) {
            curmutex->state = USED_MUTEX;
            curmutex->tid = mythread()->tid;
            initsleeplock(&curmutex->slock, "mutex lock");
            release(&mutex_table.lock);
            return i;
        }
    }
    release(&mutex_table.lock);
    return -1;
}

//this func only dealloc mutex_id of the mutexes  , change state to unused and return 0 in case of success ,else -1
int
kthread_mutex_dealloc(int mutex_id) {
    struct kthread_mutex_t *curmutex;
    acquire(&mutex_table.lock);
    if (!check_mutex_id_range_and_mutex_used(mutex_id)) {
        release(&mutex_table.lock);
        return -1;
    }
    curmutex = &mutex_table.mutexes[mutex_id];
    if (holdingsleep(&curmutex->slock)) {
        release(&mutex_table.lock);
        return -1;
    }
    curmutex->state = UNUSED_MUTEX;
    mutex_table.mutexes[mutex_id].tid = -1;
    release(&mutex_table.lock);
    cprintf("mutex number %d dealloc\n", mutex_id);
    return 0;
}

//this func only lock sleep lock in index mutex_id of the mutexes ,return 0 in case of success ,else -1
int
kthread_mutex_lock(int mutex_id) {
    struct kthread_mutex_t *curmutex;
    acquire(&mutex_table.lock);
    if (!check_mutex_id_range_and_mutex_used(mutex_id)) {
        release(&mutex_table.lock);
        return -1;
    }
    curmutex = &mutex_table.mutexes[mutex_id];
    acquiresleep(&curmutex->slock);
    release(&mutex_table.lock);
    return 0;
}

//this func only unlock sleep lock in index mutex_id of the mutexes ,return 0 in case of success ,else -1
int
kthread_mutex_unlock(int mutex_id) {
    struct kthread_mutex_t *curmutex;
    acquire(&mutex_table.lock);
    if (!check_mutex_id_range_and_mutex_used(mutex_id)) {
        release(&mutex_table.lock);
        return -1;
    }
    curmutex = &mutex_table.mutexes[mutex_id];
    releasesleep(&curmutex->slock);
    release(&mutex_table.lock);
    return 0;
}

trnmnt_tree *
trnmnt_tree_alloc(int depth) {
    if (depth < 1) {
        return 0;
    }
    return 0;
}

int
trnmnt_tree_dealloc(trnmnt_tree *tree) {
    return 0;
}

int
trnmnt_tree_acquire(trnmnt_tree *tree, int ID) {
    return 0;
}

int
trnmnt_tree_release(trnmnt_tree *tree, int ID) {
    return 0;
}
