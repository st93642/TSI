/*****************************************************************************/
/*                                                                           */
/*  main.cpp                                             TTTTTTTT SSSSSSS II */
/*                                                          TT    SS      II */
/*  By: st93642@students.tsi.lv                             TT    SSSSSSS II */
/*                                                          TT         SS II */
/*  Created: Nov 29 2025 17:19 st93642                      TT    SSSSSSS II */
/*  Updated: Nov 30 2025 01:58 st93642                                       */
/*                                                                           */
/*   Transport and Telecommunication Institute - Riga, Latvia                */
/*                       https://tsi.lv                                      */
/*****************************************************************************/

#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <cmath>

int ft_error_exit_msg(const char *msg, double *arr)
{
    printf("\n%s\n", msg);
    if (arr)
        free(arr);
    return (1);
}

int main(void)
{
    srand(time(NULL));
    int     n, choice, maxI, minI, start, end, i, swap;
    double  res, tmp, min, max;
    double  *arr;
    
    printf("\nTask number = %d\n\n", 93642 % 20);
    printf("======= Array Processing =======\n");
    printf("Size: ");
    if (scanf("%d", &n) != 1 || n <= 0)
        return  (ft_error_exit_msg("Invalid size", NULL));
    
    arr = (double *)malloc(n * sizeof(double));
    if (!arr)
        return  (ft_error_exit_msg("Memory allocation failed", NULL));
    
    printf("Fill array (1 = Manual, 2 = Auto): ");
    if (scanf("%d", &choice) != 1 || (choice != 1 && choice != 2))
        return  (ft_error_exit_msg("Invalid choice", arr));
    if (choice == 1)
    {
        i = 0;
        while (i < n)
        {
            printf("arr[%d] = ", i);
            if (scanf("%lf", &arr[i++]) != 1)
                return  (ft_error_exit_msg("Invalid input", arr));
        }
    }
    else
    {
        printf("Min: ");
        if (scanf("%lf", &min) != 1)
            return  (ft_error_exit_msg("Invalid min", arr));
        printf("Max: ");
        if (scanf("%lf", &max) != 1)
            return  (ft_error_exit_msg("Invalid max", arr));
        i = 0;
        while (i < n) arr[i++] = min + (max - min) * rand() / RAND_MAX;
    }
    
    printf("Array: ");
    i = 0;
    while (i < n) printf("%.2f ", arr[i++]);
    
    printf("\n\n======= Results =======\n");
    
    res = 0;
    i = -1;
    while (++i < n)
        if (arr[i] > 0) res += arr[i];
    printf("Sum of positives: %.2f\n", res);
    
    res = 1;
    maxI = 0;
    minI = 0;
    i = 0;
    while (++i < n)
    {
        if (fabs(arr[i]) > fabs(arr[maxI])) maxI = i;
        if (fabs(arr[i]) < fabs(arr[minI])) minI = i;
    }
    start = (maxI < minI) ? maxI + 1 : minI + 1;
    end = (maxI < minI) ? minI : maxI;
    while (start < end)
        res *= arr[start++];

    printf("Product of elements between extremes: %.2f\n", res);

    end = n - 1;
    do
    {
        swap = 0;
        i = -1;
        while (++i < end)
        {
            if (arr[i] < arr[i + 1])
            {
                tmp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = tmp;
                swap = 1;
            }
        }
        end--;
    }
    while (swap);

    printf("Sorted (descending): ");

    i = 0;
    while (i < n) printf("%.2f ", arr[i++]);
    printf("\n");
    
    free(arr);
    return (0);
}

