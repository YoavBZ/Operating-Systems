#ifndef _TOURNAMENT_TREE_H
#define _TOURNAMENT_TREE_H

#include "user.h"
#include "kthread.h"

#define PARENT(i) ((i - 1) / 2)
#define LEFT_CHILD(i) (i * 2 + 1)
#define RIGHT_CHILD(i) (i * 2 + 2)
#define NODES_NUM(depth) ((1 << depth) - 1)
#define ID_TO_MUTEX_IDX(id) (((1 << (depth - 1)) - 1) + (id / 2) ) //example : depth = 3 0,1->3 , 2,3 ->4 ,4,5->5 , 6,7->6
#define THREADS_MAX(depth) (1 << depth)

typedef struct {
    int depth;                  // The depth of the tree (the tree has 2^depth-1 nodes)
    int *mutexIds;              // A pointer mutex id's array.
    int treemutexid;
    int *threads_in;            // hold which treads id are in
    int *threads_holding;       // hold which treads id are in
} trnmnt_tree;

trnmnt_tree *
trnmnt_tree_alloc(int depth) {
    if (depth < 1) {
        return 0;
    }
    // Init tree
    trnmnt_tree *tree = malloc(sizeof(trnmnt_tree));
    if (!tree) {
        return 0;
    }
    int nodesNum = NODES_NUM(depth);
    int *mutexIds = malloc(nodesNum * sizeof(int));
    if (!mutexIds) {
        free(tree);
        return 0;
    }
    int *threads_in = malloc(THREADS_MAX(depth) * sizeof(int));
    if (!threads_in) {
        free(tree);
        free(mutexIds);
        return 0;
    }
    int *threads_holding = malloc(NODES_NUM(depth) * sizeof(int));
    if (!threads_holding) {
        free(tree);
        free(mutexIds);
        free(threads_in);
        return 0;
    }
    if (tree->treemutexid < 0) {
        free(threads_in);
        free(mutexIds);
        free(tree);
        return 0;
    }
    tree->depth = depth;
    tree->mutexIds = mutexIds;
    tree->threads_in = threads_in;
    tree->treemutexid = kthread_mutex_alloc();
    tree->threads_holding = threads_holding;

    // Init mutexes
    for (int i = 0; i < nodesNum; i++) {
        mutexIds[i] = kthread_mutex_alloc();
        if (mutexIds[i] == -1) { //fail alloc, need to release
            for (int j = 0; j < i; i++) {
                kthread_mutex_dealloc(tree->mutexIds[i]);
            }
            kthread_mutex_dealloc(tree->treemutexid);
            free(mutexIds);
            free(threads_in);
            return 0;
        }
    }
    // Init threads in
    for (int i = 0; i < THREADS_MAX(depth); i++) {
        tree->threads_in[i] = -1;
    }

    for (int i = 0; i < NODES_NUM(depth); i++) {
        tree->threads_holding[i] = -1;
    }

    return tree;
}

int
trnmnt_tree_dealloc(trnmnt_tree *tree) {
    if (!tree) {
        return -1;
    }

    kthread_mutex_lock(tree->treemutexid);
    for (int i = 0; i < THREADS_MAX(tree->depth); i++) {
        if (tree->threads_in[i] != -1) {
            // Threads array should be cleared!
            kthread_mutex_unlock(tree->treemutexid);
            return -1;
        }
    }
    tree->threads_in = 0;
    tree->threads_holding = 0;
    kthread_mutex_unlock(tree->treemutexid);
    // Retrying deallocate tree
    kthread_mutex_dealloc(tree->treemutexid);
    for (int i = 0; i < NODES_NUM(tree->depth); i++) {
        kthread_mutex_dealloc(tree->mutexIds[i]);
    }
    if (tree->mutexIds) {
        free(tree->mutexIds);
    }
    if (tree->threads_in) {
        free(tree->threads_in);
    }
    if (tree->threads_holding) {
        free(tree->threads_holding);
    }
    free(tree);
    return 0;
}

int trnmnt_tree_acquire_recursive(trnmnt_tree *tree, int mutexIdx) {
    if (mutexIdx == 0) {
        int res = kthread_mutex_lock(tree->mutexIds[mutexIdx]);
        if (res >= 0) {
            kthread_mutex_lock(tree->treemutexid);
            tree->threads_holding[0] = kthread_id();
            kthread_mutex_unlock(tree->treemutexid);
        }
        return res;
    }
    if (kthread_mutex_lock(tree->mutexIds[mutexIdx]) == -1) {
        // Thread didn't lock the mutex
        return -1;
    } else {
        kthread_mutex_lock(tree->treemutexid);
        tree->threads_holding[mutexIdx] = kthread_id();
        kthread_mutex_unlock(tree->treemutexid);
        return trnmnt_tree_acquire_recursive(tree, PARENT(mutexIdx));
    }
}

int
trnmnt_tree_acquire(trnmnt_tree *tree, int ID) {
    int depth = tree->depth;
    if (!tree->threads_in) {
        return -1;
    }
    if (ID < 0 || ID > THREADS_MAX(tree->depth)) {
        // Incorrect ID
        return -1;
    }
    kthread_mutex_lock(tree->treemutexid);
    if (tree->threads_in[ID] != -1) {
        kthread_mutex_unlock(tree->treemutexid);
        return -1;
    }
    for (int i = 0; i < NODES_NUM(tree->depth); i++) {
        if (tree->threads_holding[i] == kthread_id()) {
            kthread_mutex_unlock(tree->treemutexid);
            return -1;
        }
    }
    tree->threads_in[ID] = kthread_id();
    kthread_mutex_unlock(tree->treemutexid);

    // Fetching the mutexId to be locked
    return trnmnt_tree_acquire_recursive(tree, ID_TO_MUTEX_IDX(ID));
}

int
trnmnt_tree_release(trnmnt_tree *tree, int ID) {
    if (ID < 0 || ID > THREADS_MAX(tree->depth)) {
        // Incorrect ID
        return -1;
    }
    if (!tree->threads_in) {
        return -1;
    }

    kthread_mutex_lock(tree->treemutexid);
    int my_id = kthread_id();
    if (tree->threads_in[ID] != my_id || tree->threads_holding[0] != my_id) {
        kthread_mutex_unlock(tree->treemutexid);
        return -1;
    }
    tree->threads_in[ID] = -1;
    int i = 0;
    while (i < NODES_NUM(tree->depth)) {
        if (kthread_mutex_unlock(tree->mutexIds[i]) == 0) {
            tree->threads_holding[i] = -1;
        }
        if ((tree->threads_holding[LEFT_CHILD(i)]) == my_id) {
            i = LEFT_CHILD(i);
        } else {
            i = RIGHT_CHILD(i);
        }
    }
    kthread_mutex_unlock(tree->treemutexid);
    return 0;
}

#endif