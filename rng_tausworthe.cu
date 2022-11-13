#include "rng_tausworthe.h"
#include <iostream>
#include <cstdlib>
#include <cmath>


 __device__ __host__ Rng_Tausworthe::Rng_Tausworthe(){
  //std::cout << "CTOR" << std::endl;
  m_seed = 0;
  m_parameters.k1 = 0;
  m_parameters.k2 = 0;
  m_parameters.k3 = 0;
  m_parameters.m = 0;
}

 __device__ __host__ Rng_Tausworthe::Rng_Tausworthe(unsigned seed, Tausworthe_Parameters parameters) {
  m_seed = seed;
  m_parameters = parameters; // does it work? or should we initialize every parameter?
}

 __device__ __host__ void Rng_Tausworthe::Random(){
  unsigned b = (((m_seed << m_parameters.k1)^m_seed) >> m_parameters.k2);
  m_seed = (unsigned)(((m_seed & m_parameters.m) << m_parameters.k3)^b);
}
