/*#include "header_int128.h"*/
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>

/*typedef __uint128_t uint128;*/
/*typedef __int128_t int128;*/
typedef unsigned __int128 uint128;
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


void print_uint128(uint128 x)
{
    int count = (int) (128 / (sizeof(uint64_t) * 8));
    printf("Int64's to print: %d\n", count);
    for (int i = 0; i < count; ++i)
    {
        /*printf("%d\n", (int)x);*/
        printf("%09" PRIu64, (uint64_t) x);
        x = x >> (uint128)(sizeof(uint64_t) * 8);
    }
    printf("%s", "\n");
}

void print_uint1282(uint128 x)
{
    /*printf("%d\n", (int)x);*/
    uint64_t part2 = (uint64_t) x;
    x = x >> (uint128)64;
    uint64_t part1 = (uint64_t) x;
    printf("%" PRIu64 " ", (uint64_t) part1);
    printf("%" PRIu64 " ", (uint64_t) part2);
    printf("%s", "\n");
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
