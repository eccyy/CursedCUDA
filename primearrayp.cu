#include <iostream>
#include <cmath>
#include <string>
#include <math.h>
#include <cstdint>

__global__
void primemod(bool* a, float x)
{	
	
	int i = threadIdx.x + blockIdx.x * blockDim.x + 2;
	if(i<x)
	{
		for(int k = i; k < x; k++)
			{
				if(k%i==0 && i!=k)
				{
					a[k]=false;
				}
			}
	}
	return;
}




int main(int argc,char *argv[]){

	float x = std::stof(argv[1]);
	float n = sqrt(x); 
	
	bool * A = new bool[x];
	//bool A[x];
	cudaMallocManaged(&A,2*x*sizeof(bool));

	for (int i = 0; i < x; i++) {
        A[i] = 1;
    }
	
	//std::cout<<"sqrt of " << x << " is " << n << "\n";

	
	int blockSize = 1024;
	int numBlocks = (n + blockSize - 1) / blockSize;
	
	primemod<<<numBlocks,blockSize>>>(A,x);

	cudaDeviceSynchronize();
	
	int primecount = 0;
	for(int i = 2; i < x; i++)
	{
		if(A[i]==1)
		{
			//std::cout << i << " ";
			primecount++;
		}
		//std::cout << A[i] << " ";
	}
	
	std::cout << "primes: " << primecount;
	
	cudaFree(A);
	delete[] A;
	return 0;

}