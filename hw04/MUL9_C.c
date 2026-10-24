#include <stdio.h>

void print_cell(unsigned int row, unsigned int column)
{
    unsigned int product = row * column;
    printf("%u*%u=%u", row, column, product);
    if (column < row) {
        putchar(' ');
        putchar(' ');
        if (product < 10)
            putchar(' ');
    }
}

int main(void)
{
    unsigned int row, column;

    puts("The 9mul9 table:");
    for (row = 9; row > 0; --row) {
        for (column = 1; column <= row; ++column)
            print_cell(row, column);
        putchar('\n');
    }
    return 0;
}
