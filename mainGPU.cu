#include "stochastic_process.h"
#include <iostream>
#include <fstream> 
#include <ctime>
#include <iomanip>
#include "options/opt_european_call.h"
//#include "options/opt_european_put.h"
#include "forward_contract.h"
//#include "structs.h"
#include "main.h"

__global__ void pricing (Market_Data market_data, GPU_Parameters gpu_par,Tausworthe_Parameters par1,Tausworthe_Parameters par2,Tausworthe_Parameters par3,Seeds *d_seed, double *d_pay,double *d_stock){
 
//Rng_Combined d_omega[gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];


  Rng_Combined *d_omega = new Rng_Combined[gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];
  Stochastic_Process *d_SPX = new Stochastic_Process[gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];
  Opt_European_Call *d_oec = new Opt_European_Call[gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];

 int tid = threadIdx.x + blockIdx.x * blockDim.x;
 
 d_omega[tid] = Rng_Combined(d_seed[tid],par1,par2,par3);
 d_SPX[tid]= Stochastic_Process(&d_omega[tid]);
 d_SPX[tid].Create_Path_Exact(market_data.steps , market_data.S , market_data.T , market_data.sigma , market_data.r );
 d_oec[tid]= Opt_European_Call(&d_SPX[tid]);

//fino a qui tutto bene
 

//d_pay[tid]=d_oec[tid].Payoff(market_data.E , market_data.steps );
d_stock[tid]=d_SPX[tid].Get_path()[market_data.steps -1];  
d_pay[tid]=d_omega[tid].Get_Gauss();

//delete[] d_omega; delete[] d_SPX; delete[] d_oec;

/*
d_pay[tid]=12.3;
d_stock[tid]=0.4;
*/
}


int main(){
  std::srand(std::time(0));                        // set seed as current time;
  std::ofstream outpath_exact("path_exact.dat");   // output stream variable
  std::ofstream outpath_euler("path_euler.dat");   // output stream variable
  std::ofstream out_call("call_opt.dat");          // output stream variable
  std::cout << std::fixed << std::setprecision(2); // 2 decimal numbers

  Tausworthe_Parameters par1;
  Tausworthe_Parameters par2;
  Tausworthe_Parameters par3;
  par1.k1 = 13; par1.k2 = 19; par1.k3 = 12; par1.m = 4294967294UL;
  par2.k1 = 2; par2.k2 = 25; par2.k3 = 4; par2.m = 4294967288UL;
  par3.k1 = 3; par3.k2 = 11; par3.k3 = 17; par3.m = 4294967280UL;
//  Rng_Combined omega = Rng_Combined(seed[0], par1, par2, par3);

// setting gpu parameters
  GPU_Parameters gpu_par;
  gpu_par.THREADS_PER_BLOCK=32;
  gpu_par.BLOCK_PER_GRID=4;

//setting market data
 
  Market_Data market_data;
  market_data.S = 100.;     // $
  market_data.r = 0.0015;     // %
  market_data.sigma = 0.15;  // %
  market_data.T = 1.;       // yr
  market_data.steps = 10;
  market_data.E= 100.;

  Seeds *seed=new Seeds[gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];
  Seeds *d_seed;
  initialize(seed, gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID);
  

  cudaMalloc((void**)&d_seed, gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID*sizeof(Seeds));
  cudaMemcpy(d_seed, seed, gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID*sizeof(Seeds), cudaMemcpyHostToDevice);

//dichiaro copie host per cout risultati
/*
Stochastic_Process *SPX= new Stochastic_Process[gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];
cudaMemcpy(SPX, d_SPX, gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID*sizeof(Stochastic_Process), cudaMemcpyDeviceToHost);
*/
double *d_pay;
cudaMalloc((void**)&d_pay,  gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID*sizeof(double));
double *pay= new double[ gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];


double *d_stock;
cudaMalloc((void**)&d_stock,  gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID*sizeof(double));
double *stock= new double[ gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];

pricing <<<gpu_par.BLOCK_PER_GRID,gpu_par.THREADS_PER_BLOCK>>> (market_data,  gpu_par, par1, par2, par3,d_seed, d_pay,d_stock);

cudaMemcpy(pay, d_pay ,  gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID*sizeof(double), cudaMemcpyDeviceToHost);

cudaMemcpy(stock, d_stock ,  gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID*sizeof(double), cudaMemcpyDeviceToHost);


  Rng_Combined *dd_omega = new Rng_Combined[gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];
  Stochastic_Process *dd_SPX = new Stochastic_Process[gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];
  Opt_European_Call *dd_oec = new Opt_European_Call[gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID];

for (int tid=0; tid< gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID; ++tid){
 dd_omega[tid] = Rng_Combined(seed[tid],par1,par2,par3);
 dd_SPX[tid]= Stochastic_Process(&dd_omega[tid]);
 dd_SPX[tid].Create_Path_Exact(market_data.steps , market_data.S , market_data.T , market_data.sigma , market_data.r );
}

for(int i=0; i<gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID; ++i){
std::cout<< dd_omega[i].Get_Gauss()<< std::endl;
}

/*
for (int i=0; i<  gpu_par.THREADS_PER_BLOCK*gpu_par.BLOCK_PER_GRID; i++){
std::cout<< "pay["<<i<<"]= "<< pay[i];
std::cout<< "   stock["<<i<<"]= "<<stock[i]<< std::endl;
}

std::cout<< "Rng_Combined size= "<< sizeof(Rng_Combined)<<" stoch_process size= "<< sizeof(Stochastic_Process)<<"opt size= "<< sizeof(Opt_European_Call)<< std::endl;
*/


delete[] pay;delete[] stock; delete[] seed;
cudaFree(d_pay);cudaFree(d_stock); cudaFree(d_seed);
  outpath_euler.close(); outpath_exact.close(); out_call.close();
  return 0;
}
