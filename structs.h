struct Seeds {
  unsigned sa;
  unsigned sb;
  unsigned sc;
  unsigned sd;
};

struct Tausworthe_Parameters {
  unsigned k1;
  unsigned k2;
  unsigned k3;
  unsigned m;
};

struct Market_Data {
 double S; //prezzo iniziale
 double r; // tasso risk free
 double sigma; //volatilità
 double T; //time to maturity
 int steps; //steps temporali
 double B;
 double K;
 double E;
   
};

struct GPU_Parameters{
 int THREADS_PER_BLOCK;
 int BLOCK_PER_GRID;
};
