#include "types.h"
#include "user.h"

int main(int argc, char *argv[]){
    int pid, first_status, second_status, third_status;
    if ((pid = fork()) > 0){
        boolean passed;

        first_status = detach(pid);
        passed = (first_status == 0);

        second_status = detach(pid);
        passed &= (second_status == -1);
        
        third_status = detach(pid * 2);
        passed &= (third_status == -1);
                                
        printf(1, "Test %s\n", passed ? "passed" : "failed");
    }
    exit(0);
}