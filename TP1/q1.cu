#include <iostream>
#include <vector>


__global__ void vecmabite( int *out, int *in, std::size_t size )
{
  auto tid = threadIdx.x;
  out[ tid ] = in[ 2 * tid ];
}

int main()
{
  std::vector< int > out( 50 );
  std::vector< int > in( 100 );
  
  int * out_d = nullptr;
  int * in_d = nullptr;

  for( std::size_t i = 0 ; i < in.size() ; ++i )
  {
    in[ i ] = i;
  }
  cudaMalloc( &out_d, out.size() * sizeof( int ) );
  cudaMalloc( &in_d, in.size() * sizeof( int ) );
  cudaMemcpy( in_d, in.data(), in.size() * sizeof( int ), cudaMemcpyHostToDevice );
  
  vecmabite<<< 1, 100 >>>( out_d, in_d, out.size() );

  cudaMemcpy( out.data(), out_d, out.size() * sizeof( int ), cudaMemcpyDeviceToHost );

  for( auto const x: out )
  {
    std::cout << x << std::endl;
  }

  cudaFree( out_d );
  cudaFree( in_d );

  return 0;
}
