#ifndef __main_h__
#define __main_h__
#include "rng.h"
#include "rng_lcg.h"
#include "rng_tausworthe.h"
#include "rng_combined.h"
#include <ctime>

#define DIM 20000

void initialize (Seeds *S, int dim);

#endif
