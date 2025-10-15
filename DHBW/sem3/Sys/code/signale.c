#include <stdio.h>
#include <signal.h>
// int counter = 3;

// void sig_handler(int signum) {
//     counter--;
//     printf("\nTry again %d times.\n", counter);
// }

// int main(void) {
//     signal(SIGINT, sig_handler); //Register signal handler
//     while(counter != 0) {
//         pause();
//     }
//     return 0;
// }

int dir = 1;

int sig_handler_reverse(int signum) {
    dir *= -1;
    printf("\nDirection was changed\n");
}

int main(void) {
    signal(SIGUSR1, sig_handler_reverse);
    
    pid_t pid = fork();
    if (pid) {
        // Parent
        sleep(5);
        kill(pid, SIGUSR1);
        wait(NULL);
    }
    else {
        // Child
        int counter = 1;
        while (counter <= 10 && counter >= 1) {
            printf("CHILD: %d\n", counter);
            counter += dir;
            sleep(1);
        }
    }
    return 0;
}