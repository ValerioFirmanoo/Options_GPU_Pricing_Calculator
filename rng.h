#ifndef __rng_h__
#define __rng_h__

#include <iostream>
#include <cstdlib>
#include <cmath>

class Rng {
public:
 __device__ __host__  virtual void Random() = 0;	
};

#endif

