/*****************************************************************************/
/*                                                                           */
/*  main.cpp                                             TTTTTTTT SSSSSSS II */
/*                                                          TT    SS      II */
/*  By: st93642@students.tsi.lv                             TT    SSSSSSS II */
/*                                                          TT         SS II */
/*  Created: Nov 29 2025 17:19 st93642                      TT    SSSSSSS II */
/*  Updated: Dec 01 2025 00:03 st93642                                       */
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
    int     n, flag, start, end, i;
    double  tmp, min, max;
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
    if (scanf("%d", &flag) != 1 || (flag != 1 && flag != 2))
        return  (ft_error_exit_msg("Invalid flag", arr));
    if (flag == 1)
    {
        i = -1;
        while (++i < n)
        {
            printf("Enter element %d: ", i + 1);
            if (scanf("%lf", &arr[i]) != 1)
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
        i = -1;
        while (++i < n) arr[i] = min + (max - min) * rand() / RAND_MAX;
    }
    
    printf("Array: ");
    i = -1;
    while (++i < n) printf("%.2f ", arr[i]);
    
    printf("\n\n======= Results =======\n");
    
    tmp = 0;
    i = -1;
    while (++i < n)
        if (arr[i] > 0) tmp += arr[i];
    printf("Sum of positive elements: %.2f\n", tmp);
    
    tmp = 1;
    max = 0;
    min = 0;
    i = 0;
    while (++i < n)
    {
        if (fabs(arr[i]) > fabs(arr[(int)max])) max = i;
        if (fabs(arr[i]) < fabs(arr[(int)min])) min = i;
    }
    start = (max < min) ? max : min;
    end = (max < min) ? min : max;
    if (end - start <= 1)
    {
        printf("No elements between extremes.\n");
    }
    else
    {
        while (++start < end)
            tmp *= arr[start];

        printf("Product of elements between extremes: %.2f\n", tmp);
    }
    

    end = n - 1;
    do
    {
        flag = 0;
        i = -1;
        while (++i < end)
        {
            if (arr[i] < arr[i + 1])
            {
                tmp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = tmp;
                flag = 1;
            }
        }
        end--;
    }
    while (flag);

    printf("Sorted (descending): ");

    i = -1;
    while (++i < n) printf("%.2f ", arr[i]);

    printf("\n");
    free(arr);
    return (0);
}

