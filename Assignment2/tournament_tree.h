#ifndef _TOURNAMENT_TREE_H
#define _TOURNAMENT_TREE_H

#include "user.h"
#include "kthread.h"

#define PARENT(i) ((i - 1) / 2)
#define LEFT_CHILD(i) (i * 2 + 1)
#define RIGHT_CHILD(i) (i * 2 + 2)
#define NODES_NUM(depth) ((1 << depth) - 1)
#define ID_TO_MUTEX_IDX(id) ((1 << depth) - 1 + id)

typedef struct trnmnt_tree {
    int depth;                  // The depth of the tree (the tree has 2^depth-1 nodes)
    int *mutexIds;              // A pointer mutex id's array.
    int treemutexid;
    int tree_available;  
} trnmnt_tree;

trnmnt_tree *
trnmnt_tree_alloc(int depth) {
    if (depth < 1) {
        return 0;
    }
    int nodesNum = NODES_NUM(depth);
    int *mutexIds = malloc(nodesNum * sizeof(int));
    if (!mutexIds) {
        free(mutexIds);
        return 0;
    }
    // Init tree
    trnmnt_tree *tree = malloc(sizeof(trnmnt_tree));
    tree->depth = depth;
    tree->mutexIds = mutexIds;
    tree->treemutexid = kthread_mutex_alloc();
    tree->tree_available = 1;

    // Init mutexes
    for (int i = 0; i < nodesNum; i++) {
        mutexIds[i] = kthread_mutex_alloc();
    }
    return tree;
}

int
trnmnt_tree_dealloc(trnmnt_tree *tree) {
    int result = kthread_mutex_lock(tree->treemutexid);
    if (result < 0) {
        return -1;
    }
    tree->tree_available = 0;
    kthread_mutex_unlock(tree->treemutexid);
    while(kthread_mutex_dealloc(tree->treemutexid)!=0){};
    
    
    if (!tree) {
        return -1;
    }
    for (int i = 0; i < NODES_NUM(tree->depth); i++) {
        kthread_mutex_dealloc(tree->mutexIds[i]);
    }
    free(tree->mutexIds);
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
    int result = kthread_mutex_lock(tree->treemutexid);
    if (result < 0) {
        return -1;
    }
    if(!tree->tree_available){
        kthread_mutex_unlock(result);
        return -1;
    }
    kthread_mutex_unlock(result);
    int depth = tree->depth;
    if (ID < 0 || ID > NODES_NUM(depth)) {
        // Incorrect ID
        return -1;
    }
    // Fetching the mutexId to be locked
    int mutexId = tree->mutexIds[PARENT(ID_TO_MUTEX_IDX(ID))];
    return trnmnt_tree_acquire_recursive(tree, mutexId);
}

int
trnmnt_tree_release(trnmnt_tree *tree, int ID) {
    int result = kthread_mutex_lock(tree->treemutexid);
    if (result < 0) {
        return -1;
    }
    if(!tree->tree_available){
        kthread_mutex_unlock(result);
        return -1;
    }
    kthread_mutex_unlock(result);

    for (int i = 0; i < NODES_NUM(tree->depth); i++) {
        kthread_mutex_unlock(tree->mutexIds[i]);
    }
    return 0;
}

#endif