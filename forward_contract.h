#ifndef __forward_contract_h__
#define __forward_contract_h__

#include "stochastic_process.h"

class Forward_Contract{
public:
 __device__ __host__  Forward_Contract();
 __device__ __host__  Forward_Contract(Stochastic_Process *sp);
 __device__ __host__  ~Forward_Contract();

 __device__ __host__  double Payoff(int nsteps) { return m_sp->Get_path()[nsteps]; }

private:
  Stochastic_Process *m_sp;
};

#endif /* ifndef __forward_contract_h__ */
