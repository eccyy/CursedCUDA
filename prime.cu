#include <iostream>
#include <cmath>
#include <string>
#include <vector>
#include <cstdint>



int main(int argc,char *argv[]){

	float x = std::stof(argv[1]);
	float n = sqrt(x); 
	
	bool * A = new bool[x];

	for (int i = 0; i < x; i++) {
        A[i] = 1;
    }

	for(int i = 2; i <= n; i++)
	{	
	
		if(A[i])
		{
		
			A[i * i] = false;
			for(int m = 1; ((m * i + i * i)) < x; m++)
			{	
				int j =(m * i + i * i);
				A[j] = false;
				
			}
		}
	}
	
	
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
	delete[] A;
	return 0;

}