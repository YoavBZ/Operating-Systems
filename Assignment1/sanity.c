#include "types.h"
#include "user.h"

int main(int argc, char *argv[]){
    int pid, first_status, second_status, third_status;
    pid = fork();
    if (pid > 0){
        first_status = detach(pid);  // status = 0
        second_status = detach(pid); // status = -1, because this process has already
        // detached this child, and it doesn’t have
        // this child anymore.
        third_status = detach(pid * 2); // status = -1, because this process doesn’t
                                   // have a child with this pid.
        printf(3, "Statuses:\nFirst Status%d\nSecond Status %d\nThird Status, %d\n", first_status, second_status, third_status);
    }
    exit(0);
}