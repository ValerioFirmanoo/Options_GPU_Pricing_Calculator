#ifndef __opt_european_call_h__
#define __opt_european_call_h__

#include "opt.h"

class Opt_European_Call: public Opt {
public:
__device__ __host__ Opt_European_Call();
__device__ __host__ Opt_European_Call(Stochastic_Process *sp);
__device__ __host__ ~Opt_European_Call();


 //__device__ __host__ double Get_S() const { return m_S; }
 //__device__ __host__ double Get_E() const { return m_E; }
 //__device__ __host__ int Get_N() const { return m_N; }
 //__device__ __host__ double Get_F() const { return m_F; }

 //__device__ __host__ double Get_Price() const { return m_S; }; // or return m_F?
 __device__ __host__ virtual double Payoff( double E, int nsteps ) { return ((m_sp->Get_path()[nsteps]-E) > 0.) ? (m_sp->Get_path()[nsteps]-E) : 0.; }; //max
  //virtual void BlackScholes_Exact();

private:
  Stochastic_Process *m_sp;
  //double m_F; // option price
  //double m_S; // stock price
  //double m_E; // strike price per stock
  //int m_N; // number of stocks
};

#endif /* ifndef __forward_contract_h__ */
