#ifndef _TOURNAMENT_TREE_H
#define _TOURNAMENT_TREE_H

#include "user.h"
#include "kthread.h"

#define PARENT(i) ((i - 1) / 2)
#define LEFT_CHILD(i) (i * 2 + 1)
#define RIGHT_CHILD(i) (i * 2 + 2)
#define NODES_NUM(depth) ((1 << depth) - 1)
#define ID_TO_MUTEX_IDX(id) ((1 << depth) - 1 + id)
#define THREADS_MAX(depth) (1 << depth)

typedef struct trnmnt_tree {
    int depth;                  // The depth of the tree (the tree has 2^depth-1 nodes)
    int *mutexIds;              // A pointer mutex id's array.
    int treemutexid;
    int *threads_in;            // hold which treads id are in
} trnmnt_tree;

int clear_allocated_mutexes(trnmnt_tree *tree, int index) {
    for (int i = 0; i < index; i++) {
        kthread_mutex_dealloc(tree->mutexIds[i]);
    }
}


trnmnt_tree *
trnmnt_tree_alloc(int depth) {
    if (depth < 1) {
        return 0;
    }
    int nodesNum = NODES_NUM(depth);
    int *mutexIds = malloc(nodesNum * sizeof(int));
    int *threads_in = malloc(THREADS_MAX(depth) * sizeof(int));
    if (!mutexIds) {
        free(mutexIds);
        return 0;
    }
    // Init tree
    trnmnt_tree *tree = malloc(sizeof(trnmnt_tree));
    tree->depth = depth;
    tree->mutexIds = mutexIds;
    tree->threads_in = threads_in;

    // Init mutexes
    for (int i = 0; i < nodesNum; i++) {
        mutexIds[i] = kthread_mutex_alloc();
        if(mutexIds[i] == -1){
            clear_allocated_mutexes(tree, i);
        }
    }
    //init threads in 
    for (int i=0; i < THREADS_MAX(depth); i++){
        tree->threads_in[i] = 0;
    }
    tree->treemutexid = kthread_mutex_alloc();
    return tree;
}

int
trnmnt_tree_dealloc(trnmnt_tree *tree) {
    kthread_mutex_lock(tree->treemutexid);
    for (int i = 0; i < THREADS_MAX(tree->depth); i++) {
        if (tree->threads_in[i]) {
             kthread_mutex_unlock(tree->treemutexid);
             return -1;
        }
    }
    kthread_mutex_unlock(tree->treemutexid);
    while(kthread_mutex_dealloc(tree->treemutexid) != 0) {};

    if (!tree) {
        return -1;
    }
    for (int i = 0; i < NODES_NUM(tree->depth); i++) {
        kthread_mutex_dealloc(tree->mutexIds[i]);
    }
    free(tree->mutexIds);
    free(tree->threads_in);
    free(tree);
    return 0;
}

int trnmnt_tree_acquire_recursive(trnmnt_tree *tree, int mutexIdx) {
    if (mutexIdx == 0) {
        return 0;
    }
    if (kthread_mutex_lock(tree->mutexIds[mutexIdx]) == -1) {
        // Thread didn't lock the mutex
        return -1;
    } else {
        return trnmnt_tree_acquire_recursive(tree, PARENT(mutexIdx));
    }
}

int
trnmnt_tree_acquire(trnmnt_tree *tree, int ID) {
    if (ID < 0 || ID > THREADS_MAX(tree->depth)) {
        // Incorrect ID
        return -1;
    }

    kthread_mutex_lock(tree->treemutexid);
    if (tree->threads_in[ID]) {
        kthread_mutex_unlock(tree->treemutexid);
        return -1;
    }
    tree->threads_in[ID] = 1;
    kthread_mutex_unlock(tree->treemutexid);

    int depth = tree->depth;
 
    // Fetching the mutexId to be locked
    int mutexId = tree->mutexIds[PARENT(ID_TO_MUTEX_IDX(ID))];
    return trnmnt_tree_acquire_recursive(tree, mutexId);
}

int
trnmnt_tree_release(trnmnt_tree *tree, int ID) {
    if (ID < 0 || ID > THREADS_MAX(tree->depth)) {
        // Incorrect ID
        return -1;
    }
    
    kthread_mutex_lock(tree->treemutexid);
    if (!tree->threads_in[ID]) {
        kthread_mutex_unlock(tree->treemutexid);
        return -1;  
    }
    tree->threads_in[ID] = 0;
    kthread_mutex_unlock(tree->treemutexid);


    for (int i = 0; i < NODES_NUM(tree->depth); i++) {
        kthread_mutex_unlock(tree->mutexIds[i]);
    }
    return 0;
}

#endif