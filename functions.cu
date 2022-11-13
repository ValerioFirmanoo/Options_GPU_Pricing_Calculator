#include "main.h"

void initialize(Seeds *S, int dim){
  for (int i=0; i<dim; ++i){
    S[i].sa = std::rand();
    S[i].sb = std::rand();
    S[i].sc = std::rand();
    S[i].sd = std::rand();
    
    // seed >= 128 for Tausworthe generator
    S[i].sa = (unsigned)(128. + ((double)((RAND_MAX-128.)/RAND_MAX))*(double)S[i].sa);
    S[i].sb = (unsigned)(128. + ((double)((RAND_MAX-128.)/RAND_MAX))*(double)S[i].sb);
    S[i].sc = (unsigned)(128. + ((double)((RAND_MAX-128.)/RAND_MAX))*(double)S[i].sc);
    S[i].sd = (unsigned)(128. + ((double)((RAND_MAX-128.)/RAND_MAX))*(double)S[i].sd);
  }
}
