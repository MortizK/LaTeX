#include <stdio.h>

void printArr(char message[], int arr[], int length)
{
    printf(message);

    for (int i = 0; i < length; i++)
    {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

void merge(int arr[], int left, int mid, int right)
{
    int i, j, k;

    // Get the sizes of the left and right array
    int leftSize = mid - left + 1;
    int rightSize = right - mid;

    // Create temporary arrays
    int leftTemp[leftSize], rightTemp[rightSize];

    // Copy the data over
    for (i = 0; i < leftSize; i++)
    {
        leftTemp[i] = arr[left + i];
    }
    for (j = 0; j < rightSize; j++)
    {
        rightTemp[j] = arr[mid + 1 + j];
    }

    i = 0;
    j = 0;
    k = left;

    while (i < leftSize && j < rightSize)
    {
        if (leftTemp[i] <= rightTemp[j])
        {
            arr[k] = leftTemp[i];
            i++;
        }
        else
        {
            arr[k] = rightTemp[j];
            j++;
        }
        k++;
    }

    // Copy the remaining elements of ether left or right over
    while (i < leftSize)
    {
        arr[k] = leftTemp[i];
        i++;
        k++;
    }
    while (j < rightSize)
    {
        arr[k] = rightTemp[j];
        j++;
        k++;
    }
}

void mergeSort(int arr[], int left, int right)
{
    if (left < right)
    {
        int mid = left + (right - left) / 2;

        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);

        merge(arr, left, mid, right);
    }
}

int main(void)
{
    int arr[] = {3, 5, 1, 8, 7, 6, 2, 4};
    int n = sizeof(arr) / sizeof(arr[0]);

    printArr("Given array is\n", arr, n);

    mergeSort(arr, 0, n - 1);

    printArr("\nSorted array is\n", arr, n);

    return 0;
}