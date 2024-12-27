#include <iostream>
#include <cmath>
#include <string>
#include <math.h>
#include <cstdint>

__global__
void primemod(bool* a, float x, float n)
{	
	int i = threadIdx.x + blockIdx.x * blockDim.x + 2;	  

	if(i<x && a[i])
	{
		for(int m = 2; (m * i) <= x; m++)
		{
			if(!a[i])
			{

				break;
			}
			a[i * m] = false;
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
	
	std::cout<<"sqrt of " << x << " is " << n << "\n";

	
	int blockSize = 8;
	int numBlocks = (n + blockSize - 1) / blockSize;
	
	std::cout <<" numblocks " << numBlocks << " ";
	
	primemod<<<numBlocks,blockSize>>>(A,x,n);


	cudaDeviceSynchronize();
	
	int primecount = 0;
	for(int i = 2; i <= x; i++)
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