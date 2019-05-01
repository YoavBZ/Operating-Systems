#include "types.h"
#include "user.h"
#include "kthread.h"


// Lock global mutex to sync threads printing
static int globalMutex;

void start() {
    int mutex = kthread_mutex_alloc();
    kthread_mutex_lock(mutex);
    kthread_mutex_lock(globalMutex);
    printf(1, "ThreadID %d, MutexID %d\n", kthread_id(), mutex);
    kthread_mutex_unlock(globalMutex);
    kthread_mutex_unlock(mutex);
    kthread_mutex_dealloc(mutex);
    kthread_exit();
}

int main() {
    globalMutex = kthread_mutex_alloc();
    int threadsNum = 20;
    void *stacks[threadsNum];
    int threadIds[threadsNum];
    printf(1, "Initiating %d threads\n", threadsNum);
    for (int i = 0; i < threadsNum; ++i) {
        stacks[i] = malloc(MAX_STACK_SIZE);
        threadIds[i] = kthread_create(start, stacks[i]);
    }
    printf(0, "Joining all threads, free stacks\n");
    for (int i = 0; i < threadsNum; ++i) {
        kthread_join(threadIds[i]);
    }
    printf(0, "All threads finished!\n");
    printf(0, "Trying to join a finished thread: join return value(should be -1) = %d\n", kthread_join(threadIds[0]));
    kthread_mutex_dealloc(globalMutex);
    return 0;
}
