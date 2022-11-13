#include "rng_lcg.h"

#include <iostream>
#include <cstdlib>
#include <cmath>

 __device__ __host__ Rng_Lcg::Rng_Lcg() {
//  std::cout << "CTOR" << std::endl;
  m_seed = 0;
}

 __device__ __host__ Rng_Lcg::Rng_Lcg(unsigned seed) {
//  std::cout << "User CTOR" << std::endl;
  m_seed = seed;
}

 __device__ __host__ void Rng_Lcg::Random() {
  m_seed = 1664525*m_seed + 1013904223UL % LCG_M;
}
