#include "opt_european_call.h"
#include <cmath>

// CTOR
__device__ __host__ Opt_European_Call::Opt_European_Call(){
  m_sp = NULL;
 // m_E = 0;
 // m_N = 0;
 // m_S = 0;
//  BlackScholes_Exact();  set option price
}

// CTOR
__device__ __host__ Opt_European_Call::Opt_European_Call(Stochastic_Process *sp){
  m_sp = sp;
 // m_S = sp.Get_path()[sp.Get_steps()-1]; // last element
 // m_E = E;
 // m_N = N;
//  BlackScholes_Exact();  set option price
}

// DTOR
__device__ __host__ Opt_European_Call::~Opt_European_Call(){
  delete[] m_sp;
  m_sp=NULL;
}


// check https://goodcalculators.com/black-scholes-calculator/
/*void Opt_European_Call::BlackScholes_Exact(){
  double d1 = (std::log(m_sp.Get_S()/m_E) + (m_sp.Get_r() + 0.5*m_sp.Get_sigma()*m_sp.Get_sigma())*m_sp.Get_T())/(m_sp.Get_sigma()*std::sqrt(m_sp.Get_T()));   
  double d2 = d1 - m_sp.Get_sigma()*std::sqrt(m_sp.Get_T());
  
  m_F = m_sp.Get_S()*0.5*std::erfc(-d1/std::sqrt(2)) - m_E*0.5*std::erfc(-d2/std::sqrt(2))*std::exp(-m_sp.Get_r()*m_sp.Get_T());
}
*/
