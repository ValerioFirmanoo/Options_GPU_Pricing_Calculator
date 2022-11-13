#include "stochastic_process.h"
#include <iostream>
#include <fstream> 
#include <iomanip>
#include "options/opt_european_call.h"
#include "options/opt_european_put.h"
#include "forward_contract.h"

int main(){
  std::srand(std::time(0));                        // set seed as current time;
  std::ofstream outpath_exact("path_exact.dat");   // output stream variable
  std::ofstream outpath_euler("path_euler.dat");   // output stream variable
  std::ofstream out_call("call_opt.dat");          // output stream variable
  std::cout << std::fixed << std::setprecision(2); // 2 decimal numbers
  Seeds seed[1];
  initialize(seed, 1);
  
  Tausworthe_Parameters par1;
  Tausworthe_Parameters par2;
  Tausworthe_Parameters par3;
  par1.k1 = 13; par1.k2 = 19; par1.k3 = 12; par1.m = 4294967294UL;
  par2.k1 = 2; par2.k2 = 25; par2.k3 = 4; par2.m = 4294967288UL;
  par3.k1 = 3; par3.k2 = 11; par3.k3 = 17; par3.m = 4294967280UL;
  Rng_Combined omega = Rng_Combined(seed[0], par1, par2, par3);
  
  double S = 100.;     // $
  double r = 0.03;     // %
  double sigma = .15;  // %
  double T = 1.;       // yr
  int steps = 100;

  Stochastic_Process SPX = Stochastic_Process(S, r, sigma, omega, T, steps);
  Stochastic_Process SPU = Stochastic_Process(S, r, sigma, omega, T, steps);


  // check copy ctor
  Stochastic_Process S1 = SPX;

  // firstly create paths...
  SPX.Create_Path_Exact();
  SPU.Create_Path_Euler();
 
  // ...then create options on these paths...
  Opt_European_Call oec = Opt_European_Call(SPX, 100., 2);
  Opt_European_Put oep = Opt_European_Put(SPX, 100., 1);

  // ...and a forward contract
  Forward_Contract c1 = Forward_Contract(SPX, 1);

  for (int i=0; i<SPX.Get_steps(); ++i){
    outpath_exact << SPX.Get_path()[i] << std::endl;
    outpath_euler << SPU.Get_path()[i] << std::endl;
  }
  out_call << SPX.Get_path()[SPX.Get_steps()-1] << " " << oec.Payoff() << std::endl;

  std::cout << "Initial stock price is " << SPX.Get_path()[0] << "$" << std::endl;
  std::cout << "Final stock price is " << SPX.Get_path()[SPX.Get_steps()-1] << "$" << std::endl;
  std::cout << "Forward contract value is " << c1.Payoff() << "$: net balance is " 
            << c1.Payoff()-SPX.Get_path()[0] << "$" << std::endl;
/*
  std::cout << "European call option price F = " << oec.Get_F() << "$ - with Black-Scholes Equation evaluation." << std::endl; 
  std::cout << "European put option price F = " << oep.Get_F() << "$ - with Black-Scholes Equation evaluation." << std::endl; 
  std::cout << "For the European call one, E = " << oec.Get_E() << "$, S(" << SPX.Get_T() << ") = " 
            << SPX.Get_S() << "$" << std::endl;
  std::cout << "Payoff of the call option for " << oec.Get_N() << " stock(s) is " << oec.Payoff() 
            << "$" << std::endl;
  std::cout << "For the European put one, E = " << oep.Get_E() << "$, S(" << SPX.Get_T() << ") = " 
            << SPX.Get_S() << "$" << std::endl;
  std::cout << "Payoff of the put option for " << oep.Get_N() << " stock(s) is " << oep.Payoff() 
            << "$" << std::endl;
*/
  outpath_euler.close(); outpath_exact.close(); out_call.close();
  return 0;
}
