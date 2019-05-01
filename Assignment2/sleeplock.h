#ifndef SLEEPLOCK_H_
#define SLEEPLOCK_H_
// Long-term locks for processes
struct sleeplock {
    uint locked;       // Is the lock held?
    struct spinlock lk; // spinlock protecting this sleep lock

    // For debugging:
    char *name;        // Name of lock.
    int tid;           // Thread holding lock
};

int is_locked_sleep(struct sleeplock*);
#endif