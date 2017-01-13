#include <iostream>

int main() {
    int thread, block_x, block_y, block_z, grid_x, grid_y, grid_z, processor;

    thread = 0;
    block_x = 0;
    block_y = 0;
    block_z = 0;
    grid_x = 0;
    grid_y = 0;
    grid_z = 0;
    processor = 0;

    cudaSetDevice(0);
    cudaDeviceGetAttribute (&thread, cudaDevAttrMaxThreadsPerBlock, 0);
    cudaDeviceGetAttribute (&block_x, cudaDevAttrMaxBlockDimX, 0);
    cudaDeviceGetAttribute (&block_y, cudaDevAttrMaxBlockDimY, 0);
    cudaDeviceGetAttribute (&block_z, cudaDevAttrMaxBlockDimZ, 0);
    cudaDeviceGetAttribute (&grid_x, cudaDevAttrMaxGridDimX, 0);
    cudaDeviceGetAttribute (&grid_y, cudaDevAttrMaxGridDimY, 0);
    cudaDeviceGetAttribute (&grid_z, cudaDevAttrMaxGridDimZ, 0);
    cudaDeviceGetAttribute (&processor, cudaDevAttrMultiProcessorCount, 0);

    std::cout << "thread : " << thread << std::endl;
    std::cout << "block: " << block_x << ", " << block_y << ", " << block_z << std::endl;
    std::cout << "grid: " << grid_x << ", " << grid_y << ", " << grid_z << std::endl;
    std::cout << "processor : " << processor << std::endl;

}