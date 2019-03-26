#include "types.h"
#include "user.h"

int main(int argc, char *argv[]){
    if(argc == 2){
        int newPolicy = atoi(argv[1]);
        if (newPolicy < 1 || newPolicy > 3){
            printf(1, "Got policy %d, new policy should be between 1 to 3.\n", newPolicy);
        } else{
            policy(newPolicy);
        }
    } else{
        printf(0, "Please enter a policy between 1 to 3.\n");
    }
    exit(0);
}