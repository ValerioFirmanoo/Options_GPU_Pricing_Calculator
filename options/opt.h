#ifndef __opt_h__
#define __opt_h__

#include <iostream>
#include <cstdlib>
#include <cmath>
#include <algorithm>
#include "../stochastic_process.h"

class Opt {
public:
//  virtual void BlackScholes_Euler() = 0;
//  virtual void BlackScholes_Exact() = 0;
__device__ __host__  virtual double Payoff( double E , int nsteps) = 0;
};

#endif
