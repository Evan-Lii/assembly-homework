#include <stdio.h>
#define DIGITS 21

/* Exact decimal digits, least significant first; no native integer overflow. */
static unsigned char memo[101][DIGITS] = {{0}, {1}};
static unsigned char ready[101] = {1, 1};

const unsigned char *fib(unsigned int n)
{
    const unsigned char *left;
    const unsigned char *right;
    unsigned int digit, total, carry = 0;
    if (ready[n])
        return memo[n];
    left = fib(n - 1);
    right = fib(n - 2);
    for (digit = 0; digit < DIGITS; ++digit) {
        total = left[digit] + right[digit] + carry;
        memo[n][digit] = (unsigned char)(total % 10);
        carry = total / 10;
    }
    ready[n] = 1;
    return memo[n];
}

void print_big(const unsigned char *number)
{
    int digit = DIGITS - 1;
    while (digit > 0 && number[digit] == 0)
        --digit;
    for (; digit >= 0; --digit)
        putchar('0' + number[digit]);
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
    puts("The Fibonacci number:");
    print_big(fib(n));
    putchar('\n');
    return 0;
invalid:
    puts("Invalid input: enter 1 to 3 digits, value 1-100.");
    return 1;
}
