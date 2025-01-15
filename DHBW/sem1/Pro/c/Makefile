CC = gcc
CFLAGS = -Wall -g # -Wall steht für "Warn all" und schaltet eine Vielzahl von Warnungen ein, die standardmäßig möglicherweise nicht angezeigt werden. -g steht für "Debugging" und fügt Debugging-Informationen hinzu, die von GDB verwendet werden können.

# Prüfen, ob das Betriebssystem Windows oder Unix ist
ifeq ($(OS),Windows_NT)
    EXECUTABLE = a.exe
else
    EXECUTABLE = a.out
endif

compile: rsa.c
	$(CC) $(CFLAGS) rsa.c -o $(EXECUTABLE)

run: $(EXECUTABLE)
	./$(EXECUTABLE)

clean:
	rm -f $(EXECUTABLE) *.o