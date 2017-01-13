/**
 * Add 2 arrays of 100 elements on the device.
 */
#include <iostream>
#include <vector>
#include <algorithm>


__global__ void matadd( int ** v0, int ** v1, std::size_t size )
{
    auto tid_x = threadIdx.x;
    auto tid_y = threadIdx.y;
    v0[ tid_y ][tid_x] += v1[tid_y][ tid_x ];
}


int main(int ac, char **av)
{
    if (ac < 2)
        return (-1);
    int len = atoi(av[1]);
    std::vector<std::vector<int>>v0(len, std::vector<int>(len));
    std::vector<std::vector<int>>v1(len, std::vector<int>(len));
    std::vector< int > tmp( len );

    int ** v0_d = nullptr;
    int ** v1_d = nullptr;
    float elapsedTime;
    int k = 0;

    int thread_max = 0;
    int thread = 0;
    cudaDeviceGetAttribute(&thread_max, cudaDevAttrMaxThreadsPerBlock, 0);
    if (len / thread_max > 0)
        thread = thread_max;
    else
        thread = len;
    //REMPLISSAGE
    for (std::vector<std::vector<int>>::iterator it = v0.begin() ; it != v0.end(); ++it)
    {
        for( std::size_t i = 0 ; i < (*it).size() ; ++i )
        {
            (*it)[ i ] = i;
        }
    }
    for (std::vector<std::vector<int>>::iterator it = v1.begin() ; it != v1.end(); ++it)
    {
        for( std::size_t i = 0 ; i < (*it).size() ; ++i )
        {
            (*it)[ i ] = i;
        }
    }
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    /*
    //MALLOC matrice CUDA
    cudaMalloc( &v0_d, v0.size() * sizeof( int * ) );
    for (std::vector<std::vector<int>>::iterator it = v0.begin() ; it != v0.end(); ++it)
    {
        cudaMalloc( &(v0_d[k]), v0[k].size() * sizeof( int ) );
        ++k;
    }
    k = 0;
    cudaMalloc( &v1_d, v1.size() * sizeof( int * ) );
    for (std::vector<std::vector<int>>::iterator it = v1.begin() ; it != v1.end(); ++it)
    {
        cudaMalloc( &(v0_d[k]), v0[k].size() * sizeof( int ) );
        ++k;
    }
    //Remplissage matrice CUDA
    k = 0;
    for (std::vector<std::vector<int>>::iterator it = v0.begin() ; it != v0.end(); ++it)
    {
        cudaMemcpy( v0_d[k], (v0[k]).data(), (v0[k]).size() * sizeof( int ), cudaMemcpyHostToDevice );
        ++k;
    }
    k = 0;
    cudaMalloc( &v1_d, v1.size() * sizeof( int * ) );
    for (std::vector<std::vector<int>>::iterator it = v1.begin() ; it != v1.end(); ++it)
    {
        cudaMemcpy( v1_d[k], (v1[k]).data(), (v1[k]).size() * sizeof( int ), cudaMemcpyHostToDevice );
        ++k;
    }

    cudaEventRecord(start, 0);

    vecadd<<< 1, 1024 >>>( v0_d, v1_d, v0.size(), (v0[0]).size());
    k = 0;
    for (std::vector<std::vector<int>>::iterator it = v0.begin() ; it != v0.end(); ++it)
    {
        cudaMemcpy( (v0[k]).data(), v0_d[k], (v0[k]).size() * sizeof( int ), cudaMemcpyDeviceToHost );
        ++k;
    }
    */
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&elapsedTime, start, stop);
    for( auto const x: v0 )
    {
        std::cout << x << std::endl;
    }
    std::cout << elapsedTime << std::endl;
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    cudaFree( v0_d );
    cudaFree( v1_d );

    return 0;
}
