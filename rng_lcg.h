#ifndef __rng_lcg_h__
#define __rng_lcg_h__

#include "rng.h"
#include <iostream>
#include <cstdlib>

#define LCG_M 4294967296 // 1<<32

class Rng_Lcg: public Rng {
public:
  __device__ __host__ Rng_Lcg();
  __device__ __host__ Rng_Lcg(unsigned seed);
  __device__ __host__ ~Rng_Lcg(){};
 
  __device__ __host__ unsigned Get_Seed() const { return m_seed; }
  __device__ __host__ virtual void Random();	

private:
  unsigned m_seed;
};

#endif
