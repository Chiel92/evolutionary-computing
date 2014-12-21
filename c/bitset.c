#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef unsigned __int128 bitset;

void test123(void)
{
    printf("Hello 123\n");
}


void reverse_string(char s[])
{
    int length = strlen(s) ;
    int c, i, j;

    for (i = 0, j = length - 1; i < j; i++, j--)
    {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}

char* bitset_tostring(bitset n)
{
    char* bitstring = malloc(8 * sizeof(bitset) * sizeof(char) + 1);
    int i = 0;
    while (n) {
        if (n & 1)
            bitstring[i] = '1';
        else
            bitstring[i] = '0';

        n >>= 1;
        i++;
    }
    bitstring[i] = '\0';
    reverse_string(bitstring);
    return bitstring;
}

void print_bitset(bitset n)
{
    printf("%s\n", bitset_tostring(n));
}

int main(void)
{
    printf("Number of bits available: %d\n", (int)(sizeof(bitset) * 8));
    bitset x = (bitset)1023 << 70;
    print_bitset(x);
    return 0;
}
