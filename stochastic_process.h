#ifndef __stochastic_process_h__
#define __stochastic_process_h__

#include <ctime>
#include <fstream>
#include <iostream> 
#include <iomanip>
#include <string>
#include <cmath>
#include <algorithm>

//#include "structs.h"
#include "rng.h"
#include "rng_lcg.h"
#include "rng_tausworthe.h"
#include "rng_combined.h"

class Stochastic_Process {
public:
  __device__ __host__ Stochastic_Process();
  __device__ __host__ Stochastic_Process(Rng_Combined* omega);
  //__device__ __host__ Stochastic_Process(const Stochastic_Process &copy);
  __device__ __host__ ~Stochastic_Process();
  
  // copy assignment operator => memberwise copy
  /*
  __device__ __host__  Stochastic_Process& operator=(const Stochastic_Process &copy){
    if (this != &copy){
      delete[] m_path;
    }
    this->m_path = new double[copy.Get_Market_Data().steps]; // m_path = new double[m_steps];
    
    for (int i=0; i<copy.Get_Market_Data().steps; ++i){
      this->m_path[i] = copy.Get_path()[i];
    }
    //this->m_md = copy.Get_Market_Data();
    this->m_S_aux = copy.Get_S_aux();

    return *this;
  }
  */
  
 // __device__ __host__ Market_Data Get_Market_Data() const { return m_md; }
 // __device__ __host__ Rng_Combined Get_omega() const { return m_omega; }
  __device__ __host__ double* Get_path() const { return m_path; }
 // __device__ __host__ double Get_S_aux() const { return m_S_aux; }
  __device__ __host__ double Get_Si(int i) const { return Get_path()[i]; }
  __device__ __host__ void Integrate_Euler(int nsteps, double S, double aux , double dT, double sigma, double r);
  __device__ __host__ void Integrate_Exact(int nsteps, double S, double aux , double dT, double sigma, double r);
  __device__ __host__ void Create_Path_Euler(int nsteps, double S0 , double T, double sigma, double r);
  __device__ __host__ void Create_Path_Exact(int nsteps, double S0 , double T, double sigma, double r);

protected:
  Rng_Combined *m_omega;
  double* m_path;
  //double m_S_aux;
};

#endif
