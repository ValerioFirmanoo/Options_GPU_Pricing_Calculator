#include "main.h"

int main(){
  std::srand(std::time(0)); // set seed as current time;
  
  // LCG stuff
  std::cout << "Creating empty lcg..." << std::endl;
  Rng_Lcg l1 = Rng_Lcg();
  std::cout << "l1 seed = " << l1.Get_Seed() << std::endl;

  Seeds seed[1];
  std::cout << "Initializing seeds..." << std::endl;
  initialize(seed, 1);
  Rng_Lcg l2 = Rng_Lcg(seed[0].sa);

  std::cout << "0th seed: " << l2.Get_Seed() << std::endl;
  l2.Random();
  std::cout << "Lcg random number: " << l2.Get_Seed() << std::endl; 

  // Tausworthe stuff
  std::cout << "Creating empty Tausworthe..." << std::endl;
  Rng_Tausworthe t1 = Rng_Tausworthe();
  std::cout << "t1 seed = " << t1.Get_Seed() << std::endl;
  Tausworthe_Parameters par1;
  par1.k1 = 13; par1.k2 = 19; par1.k3 = 12; par1.m = 4294967294UL;
  Rng_Tausworthe t2 = Rng_Tausworthe(seed[0].sb, par1);
 
  std::cout << "0th seed: " << t2.Get_Seed() << std::endl;
  t2.Random();
  std::cout << "Tausworthe random number: " << t2.Get_Seed() << std::endl;

  // Combined stuff
  Tausworthe_Parameters par2;
  par2.k1 = 2; par2.k2 = 25; par2.k3 = 4; par2.m = 4294967288UL;
  Tausworthe_Parameters par3;
  par3.k1 = 3; par3.k2 = 11; par3.k3 = 17; par3.m = 4294967280UL;
  
  std::cout << "Creating empty combined..." << std::endl;
  Rng_Combined c = Rng_Combined();
  std::cout << "The standard CTOR 4 seeds are: " << (c.Get_Seeds()).sa << ", " << (c.Get_Seeds()).sb << ", " 
            << (c.Get_Seeds()).sc << ", " << (c.Get_Seeds()).sd << std::endl;
 
  Rng_Combined c1 = Rng_Combined(seed[0], par1, par2, par3);
  std::cout << "The new 4 seeds are: " << (c1.Get_Seeds()).sa << ", " << (c1.Get_Seeds()).sb << ", " 
            << (c1.Get_Seeds()).sc << ", " << (c1.Get_Seeds()).sd << std::endl;
  c1.Random(); // randomize element
  std::cout << "After randomizing, the 4 seeds are: " << (c1.Get_Seeds()).sa << ", " << (c1.Get_Seeds()).sb << ", " 
            << (c1.Get_Seeds()).sc << ", " << (c1.Get_Seeds()).sd << std::endl;
  
  std::cout << "Here is a random uniform number (µ = 0.5, σ² = 1/12): " << c1.Get_Rand() << std::endl;
  c1.RandomBoxMuller(); // create a pair of gaussian numbers  
  std::cout << "Here are 2 gaussian numbers (µ = 0, σ² = 1): "
            << "g1 = " << c1.Get_Gauss1() << ", g2 = " << c1.Get_Gauss2() << std::endl;

  // Do some statistics
  double mean = 0, variance = 0;
  double meanGauss1 = 0, varianceGauss1 = 0;
  double meanGauss2 = 0, varianceGauss2 = 0;

  Seeds ss[DIM];
  initialize(ss, DIM); 
  
  Rng_Combined cc[DIM];
  // uniform
  std::cout << std::endl << "Preparing an array with " << DIM << " elements..." << std::endl;
  for (int i=0; i<DIM; ++i){
    cc[i] = Rng_Combined(ss[i], par1, par2, par3); // initialize
    cc[i].Random();
    mean = (i*mean + cc[i].Get_Rand())/(i+1);
    variance = (i*variance + (cc[i].Get_Rand()-.5)*(cc[i].Get_Rand()-.5))/(i+1);
  }

  // gaussian
  for(int i=0; i<DIM; ++i){
    cc[i] = Rng_Combined(ss[i], par1, par2, par3); // re-initialize
    cc[i].RandomBoxMuller();
    meanGauss1 = (i*meanGauss1 + cc[i].Get_Gauss1())/(i+1);
    varianceGauss1 = (i*varianceGauss1 + (cc[i].Get_Gauss1()-0.)*(cc[i].Get_Gauss1()-0.))/(i+1);
    meanGauss2 = (i*meanGauss2 + cc[i].Get_Gauss2())/(i+1);
    varianceGauss2 = (i*varianceGauss2 + (cc[i].Get_Gauss2()-0.)*(cc[i].Get_Gauss2()-0.))/(i+1);
  }
  std::cout << "mean = " << mean << ", variance = " << variance 
            << ", relative error = " << std::fabs((mean-.5)/variance) << "(σ)" << std::endl;
  if (std::fabs((mean-.5)/variance)<1){
    std::cout << "Uniform generator passed the test!" << std::endl;
  }
  std::cout << "meanGauss1 = " << meanGauss1 << ", variance1 = " << varianceGauss1 
            <<", relative error = " << std::fabs((meanGauss1-0.)/varianceGauss1) << "(σ)" << std::endl;
  std::cout << "meanGauss2 = " << meanGauss2 << ", variance2 = " << varianceGauss2 
            <<", relative error = " << std::fabs((meanGauss2-0.)/varianceGauss2) << "(σ)" << std::endl;
  if (std::fabs((meanGauss1-0./varianceGauss1))<1 && std::fabs((meanGauss2-0./varianceGauss2))){
    std::cout << "Box Muller generator passed the test!" << std::endl;
  }

  return 0;
}
