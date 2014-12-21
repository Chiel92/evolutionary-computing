/*#include "header_int128.h"*/
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>

typedef unsigned __int128 bitset;


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
    reverse_string(bitstring);
    return bitstring;
}

void print_bitset(bitset n)
{
    printf("%s\n", bitset_tostring(n));
}

int main()
{
    /*printf("Number of bits available: %d\n", (int)(sizeof(uint128) * 8));*/
    /*uint128 a = (uint128)1 << (uint128)100;*/
    /*uint128 b = (uint128)1 << (uint128)10;*/
    /*printf("Bit count: %d\n", __builtin_popcountll(a));*/
    /*printf("Bit count: %d\n", __builtin_popcountll(b));*/

    /*print_uint1282(a);*/
    /*print_uint1282(b);*/
    /*print_bitset(a);*/
    /*print_bitset(b);*/
    bitset x = (bitset)5 << 100;
    print_bitset(x);
    return 0;
}
