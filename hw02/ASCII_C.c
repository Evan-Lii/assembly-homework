#include <stdio.h>

int main(void)
{
    int row, col;
    char ch = 'a';

    for (row = 0; row < 2; ++row) {
        for (col = 0; col < 13; ++col) {
            putchar(ch);
            ++ch;
            if (col < 12)
                putchar(' ');
        }
        putchar('\n');
    }
    return 0;
}
