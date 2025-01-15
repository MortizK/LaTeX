#include <stdio.h>

int euklid(int e, int phi, int (*pointer)[64])
{
    int r = phi % e;
    int e_ = -phi / e;

    // Saving the data to an array behind a pointer
    (*pointer)[0] = (*pointer)[0] + 4;
    int pos = (*pointer)[0];
    (*pointer)[pos] = r;
    (*pointer)[pos + 1] = phi;
    (*pointer)[pos + 2] = e_;
    (*pointer)[pos + 3] = e;

    printf("%d: %d=%d+(%d)*%d\n", pos, r, phi, e_, e);

    if (r != 1)
    {
        return 1 + euklid(r, e, pointer);
    }
}

int e_euklid(int (*pointer)[64])
{
    int end = (*pointer)[0];
    // 1 = t*x+s*y
    int t = (*pointer)[end + 2];
    int x = (*pointer)[end + 3];
    int s = 1;
    int y = (*pointer)[end + 1];

    printf("%d=%d+(%d)*%d\n", 1, x, s, y);

    for (int i = end - 4; i >= 4; i -= 4)
    {
        printf("%d=%d+(%d)*%d\n", (*pointer)[i], (*pointer)[i + 1], (*pointer)[i + 2], (*pointer)[i + 3]);

        int old_t = t;
        t = s + t * (*pointer)[i + 2];
        x = y;
        s = old_t;
        y = (*pointer)[i + 1];

        printf("%d=%d*%d+(%d)*%d\n", 1, t, x, s, y);
    }

    return (t < 0) ? t + y : t;
}

int convert(int front, int M, int n, int e)
{
    printf("%d*%d^%d\n", front, M, e);
    if (M == 1)
    {
        return front;
    }
    if (e % 2 == 1)
    {
        convert((front * M) % n, (M * M) % n, n, (e - 1) / 2);
    }
    else
    {
        convert(front, (M * M) % n, n, e / 2);
    }
}

void main()
{
    // Die Nachricht
    int M = 405;

    // Die Beiden Riesigen Primzahlen
    int p1 = 17;
    int p2 = 101;

    int n = p1 * p2;

    int phi = (p1 - 1) * (p2 - 1);

    // soll Teilerfremd zu phi sein und 1 < e
    int e = 411;

    // Speichern der Daten von dem Euklidischen Algorithmus
    int array[64];
    int(*pointer)[64];
    pointer = &array;
    (*pointer)[0] = 0;

    printf("\nEuklidischer Algorithmus\n");
    euklid(e, phi, pointer);

    // dies funktion gibt eine Form 1 = x_1*phi + x_2*e zurück, modulo phi = x_2*e
    // Und die Positive x_2 interresiert uns.

    printf("\nErweiterter Euklidischer Algorithmus\n");
    int d = e_euklid(pointer);

    printf("d: %d\n", d);

    // Nachricht Verschlüsseln
    // Die Form C modulo n = M^e
    printf("\nNachrich Verschluesseln\n");
    int C = convert(1, M, n, e);
    printf("C= %d\n", C);

    // Nachrich Entschlüsseln
    printf("\nNachrich Entschluesseln\n");
    printf("M= %d\n", convert(1, C, n, d));
}