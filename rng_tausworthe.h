#ifndef __rng_tausworthe_h__
#define __rng_tausworthe_h__

#include "rng.h"
#include <iostream>
#include <cstdlib>
#include "structs.h"

/*
struct Tausworthe_Parameters {
  unsigned k1;
  unsigned k2;
  unsigned k3;
  unsigned m;
};
*/

class Rng_Tausworthe: public Rng {
public:
 __device__ __host__  Rng_Tausworthe();
 __device__ __host__  Rng_Tausworthe(unsigned seed, Tausworthe_Parameters parameters);
 __device__ __host__ ~Rng_Tausworthe(){};

 __device__ __host__  unsigned Get_Seed() const { return m_seed; }
 __device__ __host__ Tausworthe_Parameters Get_Parameters() const { return m_parameters; }
 __device__ __host__ virtual void Random();

private:
  unsigned m_seed;
  Tausworthe_Parameters m_parameters;
};

#endif
