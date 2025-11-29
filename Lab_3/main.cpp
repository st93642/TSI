/*****************************************************************************/
/*                                                                           */
/*  main.cpp                                             TTTTTTTT SSSSSSS II */
/*                                                          TT    SS      II */
/*  By: st93642@students.tsi.lv                             TT    SSSSSSS II */
/*                                                          TT         SS II */
/*  Created: Nov 29 2025 17:19 st93642                      TT    SSSSSSS II */
/*  Updated: Nov 29 2025 23:42 st93642                                       */
/*                                                                           */
/*   Transport and Telecommunication Institute - Riga, Latvia                */
/*                       https://tsi.lv                                      */
/*****************************************************************************/

#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <cmath>

int ft_terror(const char *msg, double *arr)
{
    printf("%s\n", msg);
    if (arr)
        free(arr);
    return (1);
}

int main(void)
{
    srand(time(NULL));
    int     n, choice, maxIdx, minIdx, start, end, i, j, swapped;
    double  result, *arr, temp, min_val, max_val;
    
    printf("======= Array Processing =======\n");
    printf("Size: ");
    if (scanf("%d", &n) != 1 || n <= 0)
        return (ft_terror("Invalid size", NULL));
    
    arr = (double *)malloc(n * sizeof(double));
    if (!arr)
        return (ft_terror("Memory allocation failed", NULL));
    
    printf("Fill (1 = Manual, 2 = Auto): ");
    if (scanf("%d", &choice) != 1 || (choice != 1 && choice != 2))
        return (ft_terror("Invalid choice", arr));
    
    if (choice == 1)
    {
        i = 0;
        while (i < n)
        {
            printf("arr[%d] = ", i);
            if (scanf("%lf", &arr[i++]) != 1)
                return (ft_terror("Invalid input", arr));
        }
    }
    else
    {
        printf("Min: ");
        if (scanf("%lf", &min_val) != 1)
            return (ft_terror("Invalid min", arr));
        printf("Max: ");
        if (scanf("%lf", &max_val) != 1)
            return (ft_terror("Invalid max", arr));
        i = 0;
        while (i < n) arr[i++] = min_val + (max_val - min_val) * rand() / RAND_MAX;
    }
    
    printf("Array: ");
    i = 0;
    while (i < n) printf("%.2f ", arr[i++]);
    
    printf("\n\n======= Results =======\n");
    
    result = 0;
    i = -1;
    while (++i < n)
        if (arr[i] > 0) result += arr[i];
    printf("Sum of positives: %.2f\n", result);
    
    result = 1;
    maxIdx = 0;
    minIdx = 0;
    i = 0;
    while (++i < n)
    {
        if (fabs(arr[i]) > fabs(arr[maxIdx])) maxIdx = i;
        if (fabs(arr[i]) < fabs(arr[minIdx])) minIdx = i;
    }
    start = (maxIdx < minIdx) ? maxIdx + 1 : minIdx + 1;
    end = (maxIdx < minIdx) ? minIdx : maxIdx;
    i = start;
    while (i < end)
        result *= arr[i++];

    printf("Product of elements between extremes: %.2f\n", result);
    
    i = -1;
    while (++i < n - 1)
    {
        swapped = 0;
        j = -1;
        while (++j < n - i - 1)
        {
            if (arr[j] < arr[j + 1])
            {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = 1;
            }
        }
        if (!swapped) break;
    }
    printf("Sorted (descending): ");
    i = 0;
    while (i < n) printf("%.2f ", arr[i++]);
    printf("\n");
    
    free(arr);
    return (0);
}

