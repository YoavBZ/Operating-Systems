#include "types.h"
#include "user.h"
#include "kthread.h"


static int gm;

void start() {
    int mutex = kthread_mutex_alloc();
    kthread_mutex_lock(mutex);
    kthread_mutex_lock(gm);
    printf(1, "thread %d, mutex_id %d\n", kthread_id(), mutex);
    kthread_mutex_unlock(gm);
    kthread_mutex_unlock(mutex);
    kthread_mutex_dealloc(mutex);
    kthread_exit();
}

int main() {
    printf(1, "sanity: start\n");
    gm = kthread_mutex_alloc();
    for (int i = 0; i < 20; ++i) {
        void *stack = malloc(MAX_STACK_SIZE);
        kthread_create(start, stack);
    }
    kthread_mutex_dealloc(gm);
    return 0;
}
