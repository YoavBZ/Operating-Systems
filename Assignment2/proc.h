#include "spinlock.h"

// Per-CPU state
struct cpu {
    uchar apicid;                // Local APIC ID
    struct context *scheduler;   // swtch() here to enter scheduler
    struct taskstate ts;         // Used by x86 to find stack for interrupt
    struct segdesc gdt[NSEGS];   // x86 global descriptor table
    volatile uint started;       // Has the CPU started?
    int ncli;                    // Depth of pushcli nesting.
    int intena;                  // Were interrupts enabled before pushcli?
    struct proc *proc;           // The process running on this cpu or null
    struct thread *thread;       // The thread running on this cpu or null
};

#define NTHREADS 16

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
    uint edi;
    uint esi;
    uint ebx;
    uint ebp;
    uint eip;
};

enum threadstate {
    UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE
};

struct thread {
    uint tid;                    // Thread ID
    uint pid;                    // Proccess ID
    struct proc *proc;           // Thread Proc
    void *chan;                  // If non-zero, sleeping on chan
    struct context *context;     // swtch() here to run thread
    struct trapframe *tf;        // Trap frame for current syscall
    char *kstack;                // Bottom of kernel stack for this thread
    enum threadstate state;        // Thread state
};

enum procstate {
    UNUSED_P, USED_P, ZOMBIE_P, TERMINATING_P
};

// Per-process state
struct proc {
    uint sz;                     // Size of process memory (bytes)
    pde_t *pgdir;                // Page table
    int pid;                     // Process ID
    struct proc *parent;         // Parent process
    int killed;                  // If non-zero, have been killed
    struct inode *cwd;           // Current directory
    struct file *ofile[NOFILE];  // Open files
    char name[16];               // Process name (debugging)
    struct thread threads[NTHREADS]; // proc Thread's array
    enum procstate state;        // proc state
    struct spinlock procLock;    // proc lock
};

enum mutexstate {
    USED_MUTEX, UNUSED_MUTEX
};

struct mutex_t{
    mutexstate state;
    struct sleeplock slock;
}

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap
