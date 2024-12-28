
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#include <iostream>
#include <cmath>
#include <string>
#include <math.h>
#include <cstdint>

__global__ void primemod(bool *range, int n, int index, unsigned long int *primes)
{
    // what node/prime number will be running
    int i = threadIdx.x + blockIdx.x * blockDim.x;

    // run the ones allocated with prime numbers
    if (primes[i] != 0)
    {
        // j is the offset to the next multiple in the bucket
        for (int j = (primes[i] - ((n * index) % primes[i])); j <= n; j += primes[i])
        {

            range[j - 1] = 0;
        }
    }
}

int main(int argc, char *argv[])
{
    unsigned long *primes;
    unsigned long x;
    int n;
    bool *range;
    unsigned long primeCount = 0;

    x = std::stof(argv[1]);
    n = sqrt(x);

    // Cuda blocks/threads
    int blockSize = 32;
    int numBlocks = ((n + blockSize - 1) / blockSize);

    // bucket part of the bucket sieve
    range = new bool[n];

    // use prime number theorem to estimate how many we need to store, intit to 0 so we know which ones haven't been computed
    int totalPrimes = (x / log(x));
    primes = new unsigned long[totalPrimes];

    cudaMallocManaged(&range, sizeof(range) * n);
    cudaMallocManaged(&primes, sizeof(primes) * (x / (log(x))));
    std::memset(primes, 0, x / (log(x)));

    // find first bucket of primes
    bool *A = new bool[n];
    memset(A, 1, n);
    for (int i = 2; i < n; i++)
    {

        if (A[i])
        {
            primes[primeCount] = i;
            primeCount++;

            if ((i * i) < n)
            {
                A[i * i] = false;
            }
            for (int m = 1; (m * i + i * i) < n; m++)
            {
                int j = (m * i + i * i);
                A[j] = false;
            }
        }
    }

    // sieve the primes inside the bucket then count them
    for (int index = 1; (index * n) <= x + n; index++)
    {

        std::memset(range, 1, n);

        // run a kernel to siev the primes in the current bucket 
        primemod<<<blockSize, numBlocks>>>(range, n, index, primes);
        cudaDeviceSynchronize();

        // update the new primes
        for (int i = 0; i < n; i++)
        {
            // check the bucket for primes
            if (range[i] && ((index * n) + i + 1) <= x)
            {
                // count and add the primes in the shared array
                primeCount++;
                primes[primeCount - 1] = ((index * n) + i + 1);
            }
        }

    }

    std::cout << "primes: " << primeCount;

    cudaFree(primes);
    cudaFree(range);
    delete[] A;
    return 0;
}
