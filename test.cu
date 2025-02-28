#include <cuda_runtime.h>
#include <stdio.h>
#include <iostream>
int pointers()
{
	int* a;
	cudaMalloc(&a, 100);
	cudaFree(a);

	int test = 10;
	int* pt = &test;

	std::cout << "this is the pointer: " << pt << std::endl;
	std::cout << "this is the value: " << *pt << std::endl;


	int value = 42;
	int* ptr1 = &value;
	int** ptr2 = &ptr1;
	int*** ptr3 = &ptr2;

	std::cout << "value = " << ***ptr3 << std::endl;
	std::cout << "pointer = " << ptr3 << std::endl;

	int num = 10;
	float fnum = 3.14;
	void* vptr;

	vptr = &fnum;
	std::cout << "vptr = " << vptr << std::endl;



	return 0;
}