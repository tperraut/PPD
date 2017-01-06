
#include <iostream>
#include <vector>


__global__ void ifpairmabite( int * v, std::size_t size )
{
	// Get the id of the thread ( 0 -> 99 ).
	auto tid = threadIdx.x;
	// Each thread fills a single element of the array. 
	if (!(v[tid] % 2))
		v[ tid ] *= 2;
}


int main()
{
	std::vector< int > v( 100 );

	int * v_d = nullptr;

	// Allocate an array an the device.
	for( std::size_t i = 0 ; i < v.size() ; ++i )
	{
		v[ i ] = i;
	}

	cudaMalloc( &v_d, v.size() * sizeof( int ) );
	cudaMemcpy( v_d, v.data(), v.size() * sizeof( int ), cudaMemcpyHostToDevice );

	ifpairmabite<<< 1, 100 >>>( v_d, v.size() );

	cudaMemcpy( v.data(), v_d, v.size() * sizeof( int ), cudaMemcpyDeviceToHost );

	for( auto x: v )
	{
		std::cout << x << std::endl;
	}

	cudaFree( v_d );

	return 0;
}
