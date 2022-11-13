NVCC = nvcc
CFLAGS = -dc -std=c++11 -Wno-deprecated-gpu-targets
#ARCH = -arch=sm_20

#objects = main.o functions.o rng_lcg.o rng_tausworthe.o rng_combined.o main2.o stochastic_process.o

objects = mainGPU.o functions.o rng_lcg.o rng_tausworthe.o rng_combined.o stochastic_process.o forward_contract.o options/opt_european_call.o 

all: $(objects)
#	$(NVCC) $(ARCH) $(objects) -o executable
	$(NVCC)  $(objects) -o executable

%.o: %.cu
#	$(NVCC) $(ARCH) $(CFLAGS) $< -o $@
	$(NVCC) $(CFLAGS) $< -o $@

clean: 
	rm *.o executable options/*.o
