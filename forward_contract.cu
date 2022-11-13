#include "forward_contract.h"

// CTOR
 __device__ __host__ Forward_Contract::Forward_Contract(){
  m_sp = NULL;
 // m_N = 0;
}

// CTOR
 __device__ __host__ Forward_Contract::Forward_Contract(Stochastic_Process *sp){
  m_sp = sp;
  //m_N = N;
}

// DTOR
 __device__ __host__ Forward_Contract::~Forward_Contract(){
  delete[] m_sp;
  m_sp=NULL;
}
