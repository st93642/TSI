/*****************************************************************************/
/*                                                                           */
/*  Lab_N2.cpp                                           TTTTTTTT SSSSSSS II */
/*                                                          TT    SS      II */
/*  By: st93642@students.tsi.lv                             TT    SSSSSSS II */
/*                                                          TT         SS II */
/*  Created: Nov 07 2025 00:29 st93642                      TT    SSSSSSS II */
/*  Updated: Nov 07 2025 01:24 st93642                                       */
/*                                                                           */
/*   Transport and Telecommunication Institute - Riga, Latvia                */
/*                       https://tsi.lv                                      */
/*****************************************************************************/

#include <cstdio>

struct CubEq
{
    int     a;
    int     b;
    int     c;
    int     d;
};

void    test(const CubEq *eq, int x)
{
    if (eq->a * x * x * x + eq->b * x * x + eq->c * x + eq->d == 0)
        printf("%d ", x);
    if (-eq->a * x * x * x + eq->b * x * x - eq->c * x + eq->d == 0)
        printf("%d ", -x);
}

int     main(void)
{
    CubEq   eq;
    int     abs_d;
    int     i;

    printf("Enter coefficients a, b, c, d: ");
    scanf("%d %d %d %d", &eq.a, &eq.b, &eq.c, &eq.d);

    if (eq.d == 0)
    {
        printf("d = 0\n");
        return (0);
    }

    abs_d = eq.d < 0 ? -eq.d : eq.d;
    i = 1;

    while (i * i <= abs_d)
    {
        if (abs_d % i == 0)
        {
            test(&eq, i);
            if (i * i == abs_d) break;
            test(&eq, abs_d / i);
        }
        i++;
    }
    printf("\n");
    return (0);
}
