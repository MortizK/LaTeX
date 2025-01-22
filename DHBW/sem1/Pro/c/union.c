#include <stdio.h>
#include <math.h>

void print_bits(unsigned char x, int y)
{
    // Vom Größtem zum kleinstem Bit
    for (int i = 8 * sizeof(x) - 1; i >= 0; i--)
    {
        // 1 mit i Nullen ist die Maske.
        // Bei i = 7 -> 1000.0000
        // Bei i = 6 -> 0100.0000, usw.
        (x & (1 << i)) ? putchar('1') : putchar('0');
        // Abfrage, ob ein Leerzeichen eingebaut werden soll
        if (i % 4 == 0 && y + i != 0)
        {
            putchar(' ');
        }
    }
}

int main(void)
{
    // Union Datentypen erstellen und initializieren
    union float_bytes
    {
        float val;
        // 1 char ist ein Byte Groß und soll so vile Bytes einnehmen, wie das float
        unsigned char bytes[sizeof(float)];
    } data;

    // Eingabe vom float
    float a;
    printf("Pleas enter a float number: ");
    scanf("%f", &a);
    data.val = a;

    printf("Float <%f> in binary is: <", data.val);

    // Gehe durch die 4 Bytes, die ein float einimmt.
    for (int i = sizeof(float) - 1; i >= 0; i--)
    {
        // Da im Union, alle Werte denselben Platz einnehmen,
        // können wir auch die Daten als char einlesen, welches die größe 1 Byte hat.
        unsigned char b = data.bytes[i];
        print_bits(b, i);
    }

    printf(">.\n");

    // printf("%d, %d, %d, %d", data.bytes[3], data.bytes[2], data.bytes[1], data.bytes[0]);
    printf("sizeof(char) = %d, sizeof(float) = %d", sizeof(char), sizeof(float));
}