#ifndef __rng_combined_h__
#define __rng_combined_h__

#include "rng.h"
#include "rng_lcg.h"
#include "rng_tausworthe.h"

#include <iostream>
#include <cstdlib>

/*
struct Seeds {
  unsigned sa;
  unsigned sb;
  unsigned sc;
  unsigned sd;
};
*/

class Rng_Combined : public Rng_Lcg, Rng_Tausworthe{
public:
  __device__ __host__ Rng_Combined();
  __device__ __host__ Rng_Combined(Seeds seeds, Tausworthe_Parameters p1, Tausworthe_Parameters p2, Tausworthe_Parameters p3);
  __device__ __host__ ~Rng_Combined(){};

  __device__ __host__ Seeds Get_Seeds() const { return m_seeds; }
  __device__ __host__ virtual double Get_Rand() const { return m_rand; }
  __device__ __host__ double Get_Gauss() ; 
  //__device__ __host__ double Get_Gauss() const { return m_rand_bm2; }
  __device__ __host__ virtual void Random();
  __device__ __host__ void RandomBoxMuller();

private:
  double m_rand;
  Seeds m_seeds;
  Rng_Tausworthe m_tau1, m_tau2, m_tau3;
  Tausworthe_Parameters m_p1, m_p2, m_p3;
  Rng_Lcg m_lcg;
  double m_rand_bm1, m_rand_bm2;
  double m_a;
};

#endif
