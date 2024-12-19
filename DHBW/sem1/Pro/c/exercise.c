#include <stdio.h>

const float X = -2.f;
const float Y = -3.f;

int main(void)
{
    float xx = X * X;
    float yy = Y * Y;
    float xy = X * Y;

    float z1 = xx + yy - xy + 2.f;

    float x_sub_y = X - Y;

    float z2 = x_sub_y * x_sub_y * x_sub_y - 3.f;

    float xxx = xx * X;

    float z3_nenner = 2 * xxx - 0.5f * xx - X + 4.0f;
    float z3 = z3_nenner / Y;

    printf("z1 = %f\n", z1);
    printf("z2 = %f\n", z2);
    printf("z3 = %f\n", z3);
}