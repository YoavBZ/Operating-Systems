#include "types.h"
#include "user.h"

struct perf {
    int ctime;
    int ttime;
    int stime;
    int retime;
    int rutime;
};

void testDetach(){
    int pid, first_status, second_status, third_status;
    pid = fork();
    if (pid > 0){
        // Parent
        first_status = detach(pid);     // status = 0
        if(first_status != 0){          //should be 0
            printf(1, "Detach failed: Existing pid\n");
            goto FAIL;
        }

        second_status = detach(pid);
        if(second_status != -1){ //should be -1
            printf(1, "Detach failed: Already detached pid\n");
            goto FAIL;
        }

        third_status = detach(pid * 2);
        if(third_status != -1){ //should be -1
            printf(1, "Detach failed: Wrong pid\n");
            goto FAIL;
        }
        printf(0, "Detach test passed\n");
        return;
    } else{
        // Child
        sleep(10);
        exit(0);
    }
    FAIL:
    printf(0, "Detach test failed\n");
    return;
}

void printPerformance(struct perf* performance){
    printf(0,"perf:\n");
    printf(1,"\tctime: %d\n",performance->ctime);
    printf(1,"\tttime: %d\n",performance->ttime);
    printf(1,"\trutime: %d\n",performance->rutime);
    printf(1,"\tretime: %d\n",performance->retime);
    printf(1,"\tstime: %d\n",performance->stime);
 }

void testPolicy(int policyValue, int *status, struct perf *performance){
    policy(policyValue);
    int pid = fork();
    if(pid > 0){
        // Father wait for child and print perf
        wait_stat(status, performance);
        printPerformance(performance);
    } else{
        // Child
        for(int i = 0; i < 100; i++){
            printf(0, ".");
        }
        printf(0, "\n");
        sleep(10);
        exit(0);
    }
}

void perfPolicyTest(){
    int status;
    struct perf performance;

    printf(0,"Policy Round Robin:\n");
    testPolicy(1, &status, &performance);
    printf(0,"Policy Priority:\n");
    testPolicy(2, &status, &performance);
    printf(0,"Extended Priority Policy:\n");
    testPolicy(3, &status, &performance);
}

int main(int argc, char *argv[]){
    printf(0,"Detach Test:\n");
    testDetach();
    printf(0,"Policy & Performance Tests:\n");
    perfPolicyTest();
    exit(0);
}