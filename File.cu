#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <cassert>
#include <iostream>
#include <cstdlib>

using namespace std;

__global__ void matrixMultiplication(int* a, int* b, int* c, int N)
{
	//calc global row & column for each thread
	int row = blockIdx.y * blockDim.y + threadIdx.y;
	int col = blockIdx.x * blockDim.x + threadIdx.x;

	// boundary check for matrix
	if (row < N && col < N) {
		int temp = 0;
		for (int i = 0; i < N; i++) {
			temp += a[row * N + i] * b[i * N + col];
		}
		//write results
		c[row * N + col] = temp;
	}
}

//init square matrix w random nums

void init_matrix(int* m, int N) {
	for (int i = 0; i < N * N; i++) {
		m[i] = rand() % 100;
	}
}

//verify result on cpu
void verify_result(int* a, int* b, int* c, int N) {
	int temp;
	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			temp = 0;
			for (int k = 0; k < N; k++) {
				temp += a[i * N + k] * b[k * N + j];
			}
			//check each result
			assert(temp = c[i * N + j]);
		}
	}
}

int main() {
	//set square matrix dimension
	int N = 1 << 10;
	size_t bytes = N * N * sizeof(int);

	//allocate memory for matrices
	int* a, * b, * c;
	cudaMallocManaged(&a, bytes);
	cudaMallocManaged(&b, bytes);
	cudaMallocManaged(&c, bytes);

	// init matrices w/ random nums
	init_matrix(a, N);
	init_matrix(b, N);

	//set cooperative thread array and grid dimensions
	int threads = 16;
	int blocks = (N + threads - 1) / threads;

	// setup kernel launch params
	dim3 THREADS(threads, threads);
	dim3 BLOCKS(blocks, blocks);

	// launch kernel
	matrixMultiplication << <BLOCKS, THREADS >> > (a, b, c, N);
	cudaDeviceSynchronize();

	//verify result
	//verify_result(a, b, c, N);



	cout << "PROGRAM COMPLETED SUCCESSFULLY" << endl;
	return 0;
}
