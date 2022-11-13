#include "rng_combined.h"

#include <iostream>
#include <cstdlib>
#include <cmath>

// CTOR
 __device__ __host__ Rng_Combined::Rng_Combined() {
  m_rand = 0;
  m_seeds.sa = 0; m_seeds.sb = 0; m_seeds.sc = 0; m_seeds.sd = 0;
  m_p1.k1 = 0; m_p1.k2 = 0; m_p1.k3 = 0; m_p1.m = 0;
  m_p2.k1 = 0; m_p2.k2 = 0; m_p2.k3 = 0; m_p2.m = 0;
  m_p3.k1 = 0; m_p3.k2 = 0; m_p3.k3 = 0; m_p3.m = 0;
  m_rand_bm1 = 0; m_rand_bm2 = 0;
}

// Value CTOR
 __device__ __host__ Rng_Combined::Rng_Combined(Seeds seeds, Tausworthe_Parameters p1, Tausworthe_Parameters p2, Tausworthe_Parameters p3) {
  m_rand = 0;
  m_seeds = seeds;
  m_p1 = p1; m_p2 = p2; m_p3 = p3;
  m_a=0; //initializzo variabile ausiliaria

  m_tau1 = Rng_Tausworthe(m_seeds.sa, m_p1);
  m_tau2 = Rng_Tausworthe(m_seeds.sb, m_p2);
  m_tau3 = Rng_Tausworthe(m_seeds.sc, m_p3);
  m_lcg = Rng_Lcg(m_seeds.sd);
}

 __device__ __host__ void Rng_Combined::Random() {
  m_tau1.Random();
  m_tau2.Random();
  m_tau3.Random();
  m_lcg.Random();
  
  m_seeds.sa = m_tau1.Get_Seed();
  m_seeds.sb = m_tau2.Get_Seed();
  m_seeds.sc = m_tau3.Get_Seed();
  m_seeds.sd = m_lcg.Get_Seed();

  m_rand = 2.3283064365387e-10*(double)((m_seeds.sa)^(m_seeds.sb)^(m_seeds.sc)^(m_seeds.sd));
}

 __device__ __host__ void Rng_Combined::RandomBoxMuller(){
  m_tau1.Random();
  m_tau2.Random();
  m_tau3.Random();
  m_lcg.Random();
  m_seeds.sa = m_tau1.Get_Seed();
  m_seeds.sb = m_tau2.Get_Seed();
  m_seeds.sc = m_tau3.Get_Seed();
  m_seeds.sd = m_lcg.Get_Seed();
  double g1 = 2.3283064365387e-10*(double)((m_seeds.sa)^(m_seeds.sb)^(m_seeds.sc)^(m_seeds.sd));

  m_tau1.Random();
  m_tau2.Random();
  m_tau3.Random();
  m_lcg.Random();
  m_seeds.sa = m_tau1.Get_Seed();
  m_seeds.sb = m_tau2.Get_Seed();
  m_seeds.sc = m_tau3.Get_Seed();
  m_seeds.sd = m_lcg.Get_Seed();
  double g2 = 2.3283064365387e-10*(double)((m_seeds.sa)^(m_seeds.sb)^(m_seeds.sc)^(m_seeds.sd));
  
  m_rand_bm1 = std::sqrt(-2.*std::log(g1))*std::cos(2.*M_PI*g2);  
  m_rand_bm2 = std::sqrt(-2.*std::log(g1))*std::sin(2.*M_PI*g2);  
}


 __device__ __host__ double Rng_Combined::Get_Gauss(){
  m_a=m_rand_bm1;
  m_rand_bm1=m_rand_bm2;
  return m_a;
} 
