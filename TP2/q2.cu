#include <iostream>
#include <vector>


__global__ void vecmabite( int *out, int *in, int threads, std::size_t size )
{
    auto tid_x = threadIdx.x;
    auto tid_b = blockIdx.x;
    out[ tid_x  + threads * tid_b] = in[ 2 * (tid_x  + threads * tid_b) ];
}

int main(int ac, char **av)
{
    if (ac < 2)
        return (-1);
    int len = atoi(av[1]);
    int * out_d = nullptr;
    int * in_d = nullptr;
    int thread_max = 0;
    int thread_x = 0;

    std::vector< int > out( len );
    std::vector< int > in( 2 * len );


    cudaDeviceGetAttribute(&thread_max, cudaDevAttrMaxThreadsPerBlock, 0);
    if ((2 * len) / thread_max > 0)
        thread_x = 1024;
    else
        thread_x = thread_max;

    for( std::size_t i = 0 ; i < in.size() ; ++i )
    {
        in[ i ] = i;
    }

    cudaMalloc( &out_d, out.size() * sizeof( int ) );
    cudaMalloc( &in_d, in.size() * sizeof( int ) );
    cudaMemcpy( in_d, in.data(), in.size() * sizeof( int ), cudaMemcpyHostToDevice );

    vecmabite<<< (2 * len) / thread_max, thread_x  >>>( out_d, in_d, thread_max, out.size() );

    cudaMemcpy( out.data(), out_d, out.size() * sizeof( int ), cudaMemcpyDeviceToHost );

    for( auto const x: out )
    {
        std::cout << x << std::endl;
    }

    cudaFree( out_d );
    cudaFree( in_d );

    return 0;
}