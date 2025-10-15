#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int presentation(void) {
    int pfds[2];
    char buf[30];
    pipe(pfds);

    if (!fork()) {
        printf(" CHILD: writing to pipe\n");
        write(pfds[1], "test", 5);
        printf(" CHILD: existing\n");
    }
    else {
        printf("PARENT: reading from pipe\n");
        read(pfds[0], buf, 5);
        printf("PARENT: read \"%s\"\n", buf);
        wait(NULL);
    }
    return 0;
}

// To compile
// gcc -o ResultNameExe pipe.c
int main(void) {
    int pfds[2];
    char buf[30];
    
    if (pipe(pfds) == -1) {
        perror("pipe failed");
        return 1;
    }


    if (fork()) {
        // Parent
        close(pfds[1]);
        printf("PARENT: before\n");
        read(pfds[0], buf, 12);
        printf("PARENT: read \"%s\"\n", buf);
        close(pfds[0]);
        wait(NULL);
    }

    else {
        // CHILD
        close(pfds[0]);
        printf("CHILD: writing\n");
        (pfds[1], "Hallo, Papa!", 12);
        close(pfds[1]);
    }
    return 0;
}