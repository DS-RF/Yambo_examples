# Yambo installation on Stokes Supercluster of UCF

Copy the Yambo code from GitHub repository:

> git clone https://github.com/yambo-code/yambo.git

Go to Yambo directory:

> cd yambo

Load necessary modules for compilation:

> module load espresso   
> module list   

```
Currently Loaded Modules:
  1) ic/ic-2019.3.199                        
  2) mvapich2/mvapich2-2.3.1-ic-2019.3.199   
  3) hdf5/hdf5-1.10.4-mvapich2-2.3.1-ic-2019.3.199
  4) espresso/espresso-6.6-mvapich2-2.3.1-ic-2019.3.199
```

Configure the system and compile the code:

> ./configure  
> make all  

After the compilation (~4hrs) the yambo/bin direcory will contain the following executables:

> a2y  
> c2y  
> p2y  
> yambo  
> yambo_nl  
> yambo_ph  
> yambo_rt  
> yambo_sc  
> ypp  
> ypp_nl  
> ypp_ph  
> ypp_rt  
> ypp_sc


