#include "types.h"
#include "user.h"
#include "kthread.h"
#include "tournament_tree.h"

// Lock global mutex to sync threads printing
int globalMutex;

// ------------------------ System Test -------------------------

void systemTest() {
    printf(0, "Testing system functionality\n");
    if (fork() == 0) {
        sleep(50);
        exit();
    } else {
        wait();
    }
    printf(0, "Finished system testings!\n");
}

// ---------------- Kernel Thread & Mutex Test ------------------

void kthreadFunction() {
    int mutex;
    if ((mutex = kthread_mutex_alloc()) == -1) {
        printf(1, "ThreadID %d, allocate mutex failed\n", kthread_id());
    }
    if (kthread_mutex_lock(mutex) == -1) {
        printf(1, "ThreadID %d, lock mutex failed\n", kthread_id());
    }
    kthread_mutex_lock(globalMutex);
    printf(2, "ThreadID %d, MutexID %d\n", kthread_id(), mutex);
    kthread_mutex_unlock(globalMutex);
    if (kthread_mutex_unlock(mutex) == -1) {
        printf(1, "ThreadID %d, unlock mutex failed\n", kthread_id());
    }
    if (kthread_mutex_dealloc(mutex) == -1) {
        printf(1, "ThreadID %d, deallocate mutex failed\n", kthread_id());
    }
    kthread_exit();
}

void kthreadAndMutexTest() {
    globalMutex = kthread_mutex_alloc();
    int threadsNum = 5;
    void *stacks[threadsNum];
    int threadIds[threadsNum];
    printf(1, "Testing kthread functions\n", threadsNum);
    for (int i = 0; i < threadsNum; ++i) {
        stacks[i] = malloc(MAX_STACK_SIZE);
        threadIds[i] = kthread_create(kthreadFunction, stacks[i]);
    }
    for (int i = 0; i < threadsNum; ++i) {
        if (kthread_join(threadIds[i]) == -1) {
            printf(1, "Join thread %d failed\n", i);
        }
    }
    if (kthread_join(threadIds[0]) != -1) {
        printf(0, "Rejoining thread failed\n");
    }
    kthread_mutex_dealloc(globalMutex);
    printf(0, "Finished kthread tests!\n");
}

// ------------------- Tournament Tree Test ---------------------

trnmnt_tree *tree;
int shouldWait = 0;

void start0() {
    while (!shouldWait);
    trnmnt_tree_acquire(tree, 0);
    printf(1, "ID 0: Thread %d acquired tree\n", kthread_id());
    trnmnt_tree_release(tree, 0);
    kthread_exit();
}

void start1() {
    while (!shouldWait);
    trnmnt_tree_acquire(tree, 1);
    printf(1, "ID 1: Thread %d acquired tree\n", kthread_id());
    trnmnt_tree_release(tree, 1);
    kthread_exit();
}

void start2() {
    while (!shouldWait);
    trnmnt_tree_acquire(tree, 2);
    printf(1, "ID 2: Thread %d acquired tree\n", kthread_id());
    trnmnt_tree_release(tree, 2);
    kthread_exit();
}

void start3() {
    while (!shouldWait);
    trnmnt_tree_acquire(tree, 3);
    printf(1, "ID 3: Thread %d acquired tree\n", kthread_id());
    trnmnt_tree_release(tree, 3);
    kthread_exit();
}

void start4() {
    while (!shouldWait);
    trnmnt_tree_acquire(tree, 4);
    printf(1, "ID 4: Thread %d acquired tree\n", kthread_id());
    trnmnt_tree_release(tree, 4);
    kthread_exit();
}

void start5() {
    while (!shouldWait);
    trnmnt_tree_acquire(tree, 5);
    printf(1, "ID 5: Thread %d acquired tree\n", kthread_id());
    trnmnt_tree_release(tree, 5);
    kthread_exit();
}

void start6() {
    while (!shouldWait);
    trnmnt_tree_acquire(tree, 6);
    printf(1, "ID 6: Thread %d acquired tree\n", kthread_id());
    trnmnt_tree_release(tree, 6);
    kthread_exit();
}

void start7() {
    while (!shouldWait);
    trnmnt_tree_acquire(tree, 7);
    printf(1, "ID 7: Thread %d acquired tree\n", kthread_id());
    trnmnt_tree_release(tree, 7);
    kthread_exit();
}

void tournamentTreeTest() {
    printf(0, "Testing tournament tree functionality\n");
    int depth = 3;
    if (!(tree = trnmnt_tree_alloc(depth))) {
        printf(0, "Rejoining thread failed\n");
    }
    int threadsNum = 8;
    int threadIds[threadsNum];
    void *stacks[threadsNum];
    void (*startFunctions[])() = {start0, start1, start2, start3, start4, start5, start6, start7};
    shouldWait = 0;
    for (int i = 0; i < threadsNum; ++i) {
        stacks[i] = malloc(MAX_STACK_SIZE);
        threadIds[i] = kthread_create(startFunctions[i], stacks[i]);
    }
    shouldWait = 1;
    sleep(50);
    for (int i = 0; i < threadsNum; ++i) {
        if (kthread_join(threadIds[i]) == -1) {
            printf(1, "Join thread %d failed\n", i);
        }
    }
    printf(0, "Finished tournament tree testings!\n");
}

int main() {
    // System Test
    systemTest();

    // Kernel Threads Test
    kthreadAndMutexTest();

    // Tournament Tree Test
    tournamentTreeTest();
    exit();
}
