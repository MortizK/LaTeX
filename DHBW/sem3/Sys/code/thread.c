#include <unistd.h>
#include <sys/type.h>
#include <stdio.h>

// Von Slide S. 34 übernommen
int main() {
    int pid_t pid = fork();

    if (pid < 0) {
        // Fehler beim Erzeugen des Kindprozesses
        perror("fork failed");
        return 1;
    } else if (pid == 0) {
        // Kindprozess-Code
        print("Kindprozess, PID: %d\n", getpid());
    } else {
        // Elternprozess-Code, pid ist PID vom Kindprozess
        print("Elternprozess, Kind-PID: %d\n", pid);
        print("Elternprozess, Eltern-PID: %d\n", getpid());
    }

    return 0;
}