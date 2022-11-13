#include "stochastic_process.h"

__device__ __host__ Stochastic_Process::Stochastic_Process() {
//  m_md.S = 0.;
//  m_md.r = 0.;
//  m_md.sigma = 0.;
//  m_md.T = 0.;
//  m_md.steps = 0;
  m_omega = NULL;
  m_path = NULL;
  //m_S_aux = 0.;
  //m_S_aux = m_md.S;
}

__device__ __host__ Stochastic_Process::Stochastic_Process(Rng_Combined *omega) {
  //m_md = md;
  m_omega = omega;
  m_path = NULL;
  //m_S_aux = 0.;
  //m_S_aux = md.S; // m_S_aux = m_md.S
}

/*
__device__ __host__ Stochastic_Process::Stochastic_Process(const Stochastic_Process &copy){
//  std::cout << "copy ctor" << std::endl;
  m_S_aux = copy.Get_S_aux();
  m_md = copy.Get_Market_Data(); // struct memberwise copy
  m_omega = copy.Get_omega();
  m_path = new double[m_md.steps]; 
  for (int i=0; i<copy.Get_Market_Data().steps; ++i){
    m_path[i] = copy.Get_path()[i];
  }
}
*/

 __device__ __host__ Stochastic_Process::~Stochastic_Process(){
  delete[] m_path;
  m_path = NULL;
}


/*

__device__ __host__ void Stochastic_Process::Integrate_Euler() {
  double dT = m_md.T/(1.*m_md.steps);
  m_omega.RandomBoxMuller();
  m_md.S = m_md.S*(1 + m_md.r*dT + m_md.sigma*std::sqrt(dT)*m_omega.Get_Gauss1()); 
  m_S_aux = m_md.S*(1 + m_md.r*dT + m_md.sigma*std::sqrt(dT)*m_omega.Get_Gauss2()); 
}

__device__ __host__ void Stochastic_Process::Integrate_Exact() {
  double dT = m_md.T/(1.*m_md.steps);
  m_omega.RandomBoxMuller();
  m_md.S = m_md.S*std::exp((m_md.r-0.5*m_md.sigma*m_md.sigma)*dT + m_md.sigma*std::sqrt(dT)*m_omega.Get_Gauss1());
  m_S_aux = m_md.S*std::exp((m_md.r-0.5*m_md.sigma*m_md.sigma)*dT + m_md.sigma*std::sqrt(dT)*m_omega.Get_Gauss2());
}

__device__ __host__ void Stochastic_Process::Create_Path_Euler() {
  for (int i=0; i<m_md.steps; i+=2){
    Integrate_Euler();
    m_path[i] = m_md.S;
    m_path[i+1] = m_S_aux;
    m_md.S = m_S_aux;
  }
}

__device__ __host__ void Stochastic_Process::Create_Path_Exact() {
  for (int i=0; i<m_md.steps; i+=2){
    Integrate_Exact();
    m_path[i] = m_md.S;
    m_path[i+1] = m_S_aux;
    m_md.S = m_S_aux;
  }
}
*/

__device__ __host__ void Stochastic_Process::Integrate_Euler(int nsteps, double S, double aux , double dT, double sigma, double r) {
  m_omega->RandomBoxMuller();
  S = S*(1. + r*dT + sigma*std::sqrt(dT)*m_omega->Get_Gauss()); 
  aux = S*(1. + r*dT + sigma*std::sqrt(dT)*m_omega->Get_Gauss()); 
}


__device__ __host__ void Stochastic_Process::Integrate_Exact(int nsteps, double S, double aux , double dT, double sigma, double r) {
  m_omega->RandomBoxMuller();
  S = S*std::exp((r-0.5*sigma*sigma)*dT + sigma*std::sqrt(dT)*m_omega->Get_Gauss());
  aux = S*std::exp((r-0.5*sigma*sigma)*dT + sigma*std::sqrt(dT)*m_omega->Get_Gauss());
}


__device__ __host__ void Stochastic_Process::Create_Path_Euler(int nsteps, double S0, double T, double sigma, double r ) {
  m_path= new double [nsteps];
  double S=S0;
  double aux=0;
  double dT = T/(1.*nsteps);
  for (int i=0; i<nsteps; i+=2){
    Integrate_Euler(nsteps , S , aux , dT , sigma , r);
    m_path[i] = S;
    m_path[i+1] = aux;
    S = aux;
  }
}

__device__ __host__ void Stochastic_Process::Create_Path_Exact(int nsteps, double S0 , double T, double sigma, double r) {
  m_path= new double [nsteps];
  double S=S0;
  double aux=0;
  double dT = T/(1.*nsteps);
  for (int i=0; i<nsteps; i+=2){
    Integrate_Exact(nsteps , S , aux , dT , sigma , r);
    m_path[i] = S;
    m_path[i+1] = aux;
    S = aux;
  }
}
