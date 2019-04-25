#include "types.h"
#include "user.h"
#include "kthread.h"

//
//static int mutex = 0;
//
//static int get_mutex() {
//    if (!mutex)
//        mutex = kthread_mutex_alloc();
//    return mutex;
//
//}
//
//void start() {
//    kthread_mutex_lock(mutex);
//    printf(1, "thread %d printing, mutex_id is %d\n", kthread_id(), mutex);
//    kthread_mutex_unlock(mutex);
//    kthread_exit();
//}
//
//int
//main2() {
//    printf(1, "sanity: start\n");
//    mutex = get_mutex();
//    for (int i = 0; i < 20; ++i) {
//        void *stack = malloc(MAX_STACK_SIZE);
//        kthread_create(start, stack);
////        printf(1, "thread_id = %d\n", thread_id);
//    }
//    kthread_mutex_dealloc(mutex);
//    kthread_exit();
//    exit();
//}

void start() {
    printf(0, "!\n");
}

int main(int argc, char *argv[]) {
    printf(0, "sanity: start\n");
    void *stack = malloc(MAX_STACK_SIZE);
    kthread_create(start, stack);
    kthread_exit();
    free(stack);
    printf(0, "sanity: end\n");
    return 0;
}
