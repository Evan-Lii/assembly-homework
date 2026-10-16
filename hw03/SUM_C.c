#include <stdio.h>

unsigned int sum_to(unsigned int n)
{
    unsigned int i, total = 0;
    for (i = 1; i <= n; ++i)
        total += i;
    return total;
}

int main(void)
{
    char input[80];
    char *p;
    unsigned int n = 0;
    int digits = 0;

    puts("Please input n (1-100):");
    if (fgets(input, sizeof input, stdin) == NULL)
        goto invalid;
    for (p = input; *p != '\0' && *p != '\n'; ++p) {
        if (*p < '0' || *p > '9' || digits == 3)
            goto invalid;
        ++digits;
        n = n * 10 + (unsigned int)(*p - '0');
    }
    if (digits == 0 || n < 1 || n > 100)
        goto invalid;
    printf("The sum number:\n%u\n", sum_to(n));
    return 0;

invalid:
    puts("Invalid input: enter 1 to 3 digits, value 1-100.");
    return 1;
}
