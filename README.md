# YAMBO usage

* [Yambo installation](#yambo-installation-on-stokes-supercluster-of-ucf)    
    * [Automatic installation of version 5.0.4](#automatic-installation-of-version-504)
    * [Separate compilation of libraries](#separate-compilation-of-libraries)
    * [Compilation version 5.1.1](#compilation-version-511)   
* [Example 1. Convert QE ground state calculation to Yambo format](#example-1)  
* [Example 2. GW calculation](#example-2)  
    * [Run GW](#run-gw)
    * [Plot band structure](#plot-band-structure)
* [Example 3. Self-consistent GW](#example-3)
* [Example 4. Parallel calculation](#example-4)
* [Example 5. Linear response (LR) with GW - BSE](#example-5)  
* [Example 6. Linear response with TD BSE in IPA approximation](#example-6)
* [Example 7. Second harmonic generation (SHG) with IPA - TD BSE](#example-7)
* [Example 8. LR and SHG with GW - TD BSE](#example-8)   
    * [Setup NL calculation](#setup-nl-calculation)
    * [Collisions calculation](#collisions-calculation)
    * [Linear response](#linear-response)
    * [Analyze results for LR: plot &epsilon;(E)](#analyze-results-for-lr)
    * [SHG with GW-TD BSE](#shg-with-gw-td-bse)
    * [Analyze results for SHG: plot &chi;<sup>(2)</sup>(E)](#analyze-resulst-for-shg) 



# [Yambo](http://www.yambo-code.org/) installation on [Stokes Supercluster of UCF](https://arcc.ist.ucf.edu)   

## Automatic installation of version 5.0.4   

Copy the latest release of Yambo code and unpack:  

> wget https://github.com/yambo-code/yambo/archive/refs/tags/5.0.4.zip  
> unzip 5.0.4.zip

Go to Yambo directory:

> cd yambo_5.0.4  

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

> ./configure --enable-memory-profile --enable-dp --enable-open-mp    
> make all  

*--enable-memory-profile* is necessary in order to have information in Yambo output about used memory,   
*--enable-dp* asks to compile the code with double precision necessary for optical calculations,    
*--enable-open-mp* tag asks to compile hybrid OpenMP/MPI version of the code.   

In order to see [all available options](http://www.yambo-code.org/wiki/index.php?title=Configure-5.0) for configuration type:

> ./configure --help

After the compilation (~4hrs) the yambo/bin directory will contain the following executables:
```
a2y  
c2y  
p2y  
yambo  
yambo_nl  
yambo_ph  
yambo_rt  
yambo_sc  
ypp  
ypp_nl  
ypp_ph  
ypp_rt  
ypp_sc
```   

where   
*p2y/a2y/c2y* - programs for data conversion from [QE](https://www.quantum-espresso.org/)/[ABINIT](https://www.abinit.org/)/[CPMD](https://www.cpmd.org) format   
*yambo*    - main module   
*yambo_nl* - non-linear calculations (Berry phase approach)    
*yambo_ph* - phonon calculation   
*yambo_rt* - real-time dynamics   
*yambo_sc* -    
*ypp*      - post-processing tools

Copy the executables into default directory:

> cp yambo_5.0.4/bin/* ~/bin/

Check yambo version:

> yambo -version

```
This is yambo - MPI+OpenMP+HDF5_IO - Ver. 5.0.4 Revision 19595 Hash 896bffc02
```

## Separate compilation of libraries   

Here we consider how to compile Yambo code using external libraries necessary for the code, HDF5, LibXC.  

Let us directory with external libraries will be ~/Libraries/.   

Load fortran/c complier and mvapich libaries:   

> module load mvapich2/mvapich2-2.3.2-gcc-9.1.0   
> module list

```
Currently Loaded Modules:
  1) gcc/gcc-9.1.0   
  2) mvapich2/mvapich2-2.3.2-gcc-9.1.0
```

### Compilation of LibXC library      

Download LibXC library and unpack:   

> cd ~/Libraries/   
> wget http://www.tddft.org/programs/libxc/down.php?file=5.2.2/libxc-5.2.2.tar.gz   
> tar -xvf libxc-5.2.2.tar.gz  
> cd libxc-5.2.2   
> ./configure FC=gfortran F77=gfortran CC=gcc    
> make    
> make install     

The library files will be in ~/libxc-5.2.2/bin

### Compilation of HDF5 library   

Download archive from https://www.hdfgroup.org   

> tar -xvf hdf5-1.12.0.tar.gz   
> cd hdf5-1.12.0   
> ./configure FC=gfortran F77=gfortran CC=gcc --enable-fortran   
> make   
> make install   

The library modules will be in ~/hdf5-1.12.0/hdf5     

### Compiling Yambo code with external libraries   

> ./configure FC=gfortran F77=gfortran CC=gcc --enable-dp --with-libxc-path=`~`/Libraries/libxc-5.2.2/bin    
>                                                         --with-hdf5-path=`~`/Libraries/hdf5-1.12.0/hdf5 


## Compilation version 5.1.1   

> module load hdf5/hdf5-1.10.4-mvapich2-2.3.1-ic-2019.3.199   
> ./configure --enable-dp --with-hdf5-path=/apps/hdf5/hdf5-1.10.4-mvapich2-2.3.1-ic-2019.3.199/   
> make all    
> yambo -version

```
This is yambo - MPI+HDF5_MPI_IO - Ver. 5.1.1 Revision 21528 Hash 0e32e3c52
```

[Go to top](#yambo-usage)

# Example 1

## Ground State Calculation as Starting Point for YAMBO

In this example we follow the recommendations from [https://www.paradim.org](https://www.paradim.org/toolbox/computation/tutorials)

The detailed description of the example is in the [pdf file](Example_01/YAMBO_Tutorial-1_Ground_State_Calculation_as_Starting_Point_for_YAMBO.pdf)

### QE scf calculation

All input files are here [Example_01](Example_01)

To run the example (calculation time is 3s):

> sbatch [job_QE](Example_01/job_QE)     

For optimized parameters for QE calculation see [QE examples](https://github.com/Dmitry-Skachkov/QE_examples)     

### Converting QE files to YAMBO

After the QE calculation it is necessary to convert QE files to Yambo format. The detailed notes about the conversion are [here](Example_01/YAMBO_Tutorial-2_File_Conversion_from_QE_to_YAMBO.pdf).

> cd d.save  
> p2y  

The program *p2y* creates directory SAVE with converted files:
```
ns.db1
ns.kb_pp_*
ns.wf_*
```

After that it is necessary to run Yambo initialization:    

> yambo  

After that new files will be in SAVER directory:
```
ndb.gops
ndb.kindx
```


[Go to top](#yambo-usage)

# Example 2

## GW calculation with YAMBO

This example is taken from [https://www.paradim.org](https://www.paradim.org/toolbox/computation/tutorials)   

In order to run this example it is necessary to run [Example 1](#example-1) at first and convert QE results to Yambo format. 

The directory with input files for this example is [Example_02](Example_02)  

### Run GW

Create input file for GW calculation:

> yambo -x -g n -p p -F yambo_gw.in 

and change the response block to 6-10 Ry:

```
NGsBlkXp= 6                Ry    # [Xp] Response block size
```

The detailed description of the example is [here](Example_02/YAMBO_Tutorial-3.1_GW_Band_Structure.pdf)

To run GW calculation (calculation time is 3m):

> sbatch [job_yambo](Example_02/job_yambo)  

Yambo output with GW calculation is here [r_HF_and_locXC_gw0_dyson_em1d_ppa_01](Example_02/r_HF_and_locXC_gw0_dyson_em1d_ppa_01)  
 
After the calculation SAVE directory will contain the files:
```
ndb.em1s*
ndb.QP
```

### Plot Band Structure 

How to plot band structure [detailed description in pdf file](Example_02/YAMBO_Tutorial-3.2_Postprocessing_of_the_quasiparticle_energies_to_obtain_the_GW_band_structure.pdf)  

Generate input file for post-processing calculation        
> ypp -s b 

Remove symmetry:

> ypp -y  

Correct input file by uncomment **RmTimeRev** and insert the direction of the field.

> ypp  
> cd FixSymm  
> yambo  
> ypp -s b -V qp    

The last command creates the file ypp.in, which is necessary to correct, change interpolation to BOLTZ in order to have smooth band curves:   
```
INTERP_mode= "BOLTZ"                # Interpolation mode (NN=nearest point, BOLTZ=boltztrap aproach)
```

select 99 bands for plotting:    
```
% BANDS_bands     
   1 |  99 |                         # Number of bands     
```

change number of divisions for plotting:     
```
BANDS_steps= 20                  # Number of divisions     
```

add QP database from GW calculation: 
```
GfnQPdb= "E < SAVE/ndb.QP"                  # [EXTQP G] Database action
```

and insert the k-points path:   
```
%BANDS_kpts                      # K points of the bands circuit     
0.00000 |0.000000 |0.00000 |     
0.66666 |-0.33333 |0.00000 |     
0.50000 |0.000000 |0.00000 |     
0.00000 |0.000000 |0.00000 |     
%     
```

In order to generate the correct k-point pathway corresponding to the initial axes see [Calculate band structure using QE](https://github.com/Dmitry-Skachkov/QE_examples#band-structure-calculation-in-qe)    
*Tip*. You can run 'bands' calculation of QE with only one intermediate point between the points in order to generate necessary k-points list for Yambo input (use cryst. coord. representation).

The corrected file [ypp.in](Example_02/ypp.in)  

Run the script [yambo_band_plot.sh](Example_02/yambo_band_plot.sh):   

> yambo_band_plot.sh   

The band structure will be in the file bands_pl_yambo.dat.


[Go to top](#yambo-usage)   


# Example 3

## Self-consistent GW

Following [this tutorial](http://www.yambo-code.org/wiki/index.php?title=Self-consistent_GW_on_eigenvalues_only) 

### Automatic self-consistent procedure

Create input file for self-consitent GW (evGW) calculation:

> yambo -d f -g n -p p -V qp -F yambo_evGW.in    

Correct GWIter parameter to 2:
```
GWIter=2                         # [GW] GW  self-consistent (evGW)  iterations on eigenvalues
```

Correct QPkrange for bands (4 occupied + 6 virtual):

```
%QPkrange   
1|64|5|14|   
```   

Submit job:   

> sbatch job_yambo_evGW     

### Manual self-consistent procedure   

Submit the job    

> sbatch [job_yambo_gw](Example_03/job_yambo_gw)   

[Go to top](#yambo-usage)    

# Example 4  

## YAMBO parallel calculation on several nodes

Yambo code has several levels of paralelization. The parameters for paralelization can be placed in input file [yambo.in](Example_04/yambo1.in). In order to generate parameters for paralelization you should use option *-V par*:

> yambo -x -g n -p p -V par   


```
NLogCPUs = 10                 # [PARALLEL] Live-timing CPU`s (0 for all)
PAR_def_mode= "workload"      # [PARALLEL] Default distribution mode ("balanced"/"memory"/"workload")

DIP_CPU= "2 10 24"            # [PARALLEL Dipoles] CPUs for each role
DIP_ROLEs= "k c v"            # [PARALLEL Dipoles] CPUs roles (k,c,v)
DIP_Threads= 0                # [OPENMP   Dipoles] Number of threads for dipoles

X_and_IO_CPU= "1 2 1 5 48"    # [PARALLEL Polarisability] CPUs for each role
X_and_IO_ROLEs= "q g k c v"   # [PARALLEL Polarisability] CPUs roles (q,g,k,c,v)
X_and_IO_nCPU_LinAlg_INV=-1   # [PARALLEL Polarisability] CPUs for Linear Algebra (for ScaLapack)
X_and_IO_Threads= 0           # [OPENMP   Polarisability] Number of threads for response functions

SE_CPU= "1 24 20"             # [PARALLEL Self-Energy] CPUs for each role
SE_ROLEs= "q qp b"            # [PARALLEL Self-Energy] CPUs roles (q,qp,b)
SE_Threads= 0                 # [OPENMP   Self-Energy] Number of threads for self-energy

```
The detailed description of these parameters is [here](http://www.yambo-code.org/wiki/index.php?title=GW_parallel_strategies) By default *SE_Threads*, *DIP_Threads*, and *X_Threads* are set to zero and controlled by the OMP_NUM_THREADS environment variable.

```
g      parallelism over G-vectors   
k      parallelism over k-points   
c/v    parallelism over conduction/valence bands   
q      parallelism over transferred momenta   
qp     parallelism over qp corrections to be computed  (nk)
b      parallelism over (occupied) density matrix (or Green's function) bands  (m)
```

Default parameters for 10x48 as an example:
```
DIP
   k     c     v                   Mode
   1     1    480                workload
   5     6     16                memory

X 
   q     g     k     c    v        Mode
   12    1    40     1    1       workload
    2    1    10     6    4       balanced
    1    1     5     6   16       memory
```

Here are few examples of running Yambo on 10 nodes with 48 cores:

```
  k   c   v   q  qp   b  OpenMP threads    t_calc.
  1  24  20   1  10  48      1              3h1m
  2  24  10   1  10  48      1              2h54m
  6   4  20   1  10  48      1              2h45m
  6   4  20   2  10  24      1              2h10m     <-- optimized
  6   4  20   4  10  12      1              3h47m
```   
The job running script for 1 OpenMP thread [job_yambo_10x48_1](Example_04/job_yambo_10x48_1)   
The job running script for 2 OpenMP threads [job_yambo_10x48_2](Example_04/job_yambo_10x48_2)   
The job running script for 4 OpenMP threads [job_yambo_10x48_4](Example_04/job_yambo_10x48_4)   

Please note, that in order to use hybrid OpenMP/MPI calculation you need to have hybrid OpenMP/MPI compiled version of Yambo, and in order to use parallel calculation for linear algebra (X_nCPU_LinAlg_INV=480) you need to compile Yambo with [ScaLapack library](http://www.netlib.org/scalapack/). 

[Go to top](#yambo-usage)

# Example 5

## Calculation of Optical Properties with YAMBO

The detailed description of the example [YAMBO_Tutorial-4_Calculation_of_Optical_Properties_with_YAMBO.pdf](Example_05/YAMBO_Tutorial-4_Calculation_of_Optical_Properties_with_YAMBO.pdf)   

This example is taken from [https://www.paradim.org](https://www.paradim.org/toolbox/computation/tutorials)  

In order to run this example it is necessary to run [Example 1](#converting-qe-files-to-yambo) at first and convert QE results to Yambo format. 

To generate the input file for the GW-BSE calculation:

> yambo -o b -k sex -y h -V qp -F yambo_lr.in 

To correct *yambo_lr.in* file to insert GW QP correction:
```
KfnQPdb= "E < SAVE/ndb.QP" # [EXTQP BSK BSS] Database    
```

And insert commands for parallel calculation:
```
NLogCPUs = 10                 # [PARALLEL] Live-timing CPU`s (0 for all)
PAR_def_mode= "workload"      # [PARALLEL] Default distribution mode ("balanced"/"memory"/"workload")
```

The corrected file [yambo_lr.in](Example_05/yambo_lr.in)  

To run the GW-BSE calculation (calculation time is 16m):

> sbatch [job_yambo_lr](Example_05/job_yambo_lr)  

The results of GW-BSE calculation is in the file [r_optics_dipoles_bss_bse_em1d_ppa](Example_05/r_optics_dipoles_bss_bse_em1d_ppa) with the results in file [o.eps_q1_haydock_bse](Example_05/o.eps_q1_haydock_bse), EPS-Im versus E.   

[Go to top](#yambo-usage)



# Example 6  

## Linear responce 

This example is from [Lumen web-site](http://www.attaccalite.com/lumen/linear_response.html) 

### Setup calculation

At first, you need to do QE calculation ([scf](Example_06/) and [nscf](Example_06/)) and convert the data files to Yambo format (see [Example 1](#example-1)). SAVE directory will contain the following files:
```
ns.db1
ns.kb_pp_pwscf_*
ns.wf
ns.ws_fragments_*
```

In order to setup calculation for linear responce:

> yambo_nl -i -V RL -F setup.in

Reduce number of G-vectors:

```
MaxGvecs=  1000           RL    # [INI] Max number of G-vectors planned to use
```

Then run initialization of non-liner calculation:

> yambo_nl -F setup.in   

You will get the responce:
```
 __    __ ______           ____     _____
/\ \  /\ \\  _  \  /"\_/`\/\  _`\ /\  __`\
\ `\`\\/"/ \ \L\ \/\      \ \ \L\ \ \ \/\ \
 `\ `\ /" \ \  __ \ \ \__\ \ \  _ <" \ \ \ \
   `\ \ \  \ \ \/\ \ \ \_/\ \ \ \L\ \ \ \_\ \
     \ \_\  \ \_\ \_\ \_\\ \_\ \____/\ \_____\
      \/_/   \/_/\/_/\/_/ \/_/\/___/  \/_____/


 <---> [01] MPI/OPENMP structure, Files & I/O Directories
 <---> [02] CORE Variables Setup
 <---> [02.01] Unit cells
 <---> [02.02] Symmetries
 <---> [02.03] Reciprocal space
 <---> [02.04] K-grid lattice
 <---> Grid dimensions      :  18  18
 <---> [02.05] Energies & Occupations
 <---> [03] Transferred momenta grid and indexing
 <---> [04] Timing Overview
 <---> [05] Memory Overview
 <---> [06] Game Over & Game summary
```
Then it is necessary to reduce symmetries. For that, we generate input file for *ypp*:

> ypp -y     

and in the input file we add *y* component of electric field (Efield1) and uncomment RmTimeRev:
```
fixsyms                            # [R] Reduce Symmetries
% Efield1
 0.00     | 1.00     | 0.00     |  # First external Electric Field
%
% Efield2
 0.00     | 0.00     | 0.00     |  # Additional external Electric Field
%
#RmAllSymm                         # Remove all symmetries
RmTimeRev                          # Remove Time Reversal
#RmSpaceInv                        # Remove Spatial Inversion
```
After that run ypp:  

> ypp   

go to *FixSymm* directory and run setup again:

>  yambo_nl -F ../setup.in   

### Real time dynamics for linear response   

Now everything is ready for calculation of linear response. For that we generate input file:   

> yambo_nl -u n -F input_lr.in -V par    

and change the band range, simulation time, energy steps, dampling, electric field, and type of electric field:

```
% NLBands
  3 | 6 |                   # [NL] Bands
%
NLtime=55.000000      fs     # [NL] Simulation Time
NLEnSteps= 1                 # [NL] Energy steps
NLDamping= 0.000000    eV    # [NL] Damping
% ExtF_Dir
 0.000000 | 1.000000 | 0.000000 |# [NL ExtF] Versor
%
ExtF_kind= "DELTA"               # [NL ExtF] Kind(SIN|SOFTSIN|RES|ANTIRES|GAUSS|DELTA|QSSIN)
```
where 3 and 4 are two valence bands and 5, 6 are two bands from conduction band. 
 
Run real time dynamics to calculate linear response (calc. time 2m30s):   

> yambo_nl -F input_lr.in   

File [o.polarization_F1](Example_06/o.polarization_F1) will contain the polarization. 
   
[Go to top](#yambo-usage)

# Example 7  

## Second harmonic generation (SHG) 

This example is from Lumen web-site [SHG](http://www.attaccalite.com/lumen/shg_in_AlAs.html) and [Correlation and SHG](http://www.attaccalite.com/lumen/correlation_and_shg.html)   

Do [Example 6](#example-6) **Setup calculation**, and then generate input file for second harmonic calculation:

> yambo_nl -u -V par -V qp -F yambo_shg.in     

where -V qp means quasy-particle correction (by GW or by scissor correction)   
and -V par asks to generate parameters for parallelization

Change the band range, energy range, energy steps, damping, electric field, and set scissor correction to 0.5 eV:
```
% NLBands
  3 | 6 |                          # [NL] Bands
%
% NLEnRange
  1.000000 | 5.000000 | eV         # [NL] Energy range
%
NLEnSteps= 10                      # [NL] Energy steps
NLDamping= 0.150000    eV          # [NL] Damping
% ExtF_Dir
 0.000000 | 1.000000 | 0.000000 |  # [NL ExtF] Versor
% GfnQP_E
 0.500000 | 1.000000 | 1.000000 |        # [EXTQP G] E parameters  (c/v) eV|adim|adim
%

```
The modified input file [yambo_shg.in](Example_07/yambo_shg.in)

Submit job on 48 cores for real-time dynamics (calc. time 40m7s):   

> sbatch [job_yambo_nl](Example_07/job_yambo_nl)   


[Go to top](#yambo-usage)     


# Example 8   

## Linear response (LR) and secong harmonic generation (SHG) with GW - time dependent BSE   

Following [Lumen web-site](http://www.attaccalite.com/lumen/real_time_bse.html)

### Setup NL calculation   


> yambo_nl -i -V RL -F setup.in                
> yambo_nl -F setup.in                        
> ypp -y                                        
> ypp                                           
> cd FixSymm                                  
> yambo_nl -F ../setup.in                   

For more detailes of this step please see [Example 6](#example-6) **Setup calculation**.     


### Collisions calculation   

Generate input file for collisions calculation:

> yambo_nl -d s -e -v h+sex -V qp -F yambo_coll.in       

and reduce the parameters of calculation:

```
% COLLBands
   5 |  14 |                   # [COLL] Bands for the collisions
%
```   
Here 5-8 is the occupied orbitals + 6 virtual (9-14).

Add GW QP database:

```
XfnQPdb= "E < SAVE/ndb.QP"
```
Change response block:

```
NGsBlkXs= 10 Ry    
```    

For recommended converged parameters see [here](http://www.yambo-code.org/wiki/index.php?title=GW_hBN_Yambo_Virtual_2021_version)

Correct electric field direction.   

Submit the job for calculation:    

> sbatch [job_yambo_coll](Example_08/job_yambo_coll)   

Calculation time is 1h for "workload" and 1h40m for "balanced" parallel distribution on 8 nodes with 48 cores.   

```
PAR_def_mode= "workload"      # [PARALLEL] Default distribution mode ("balanced"/"memory"/"workload")
```

After the calculation the folder SAVE will contain:

```
ndb.COLLISIONS*
ndb.dipoles
ndb.em1s*
```   
### Linear response   

To generate input file for linear response:   

> yambo_nl -u n -V qp -F yambo_lr.in    

and change the NLBands according to COLLBands, change verbosity to high, change the method of integration, simulation time (55 fs), energy steps (1), dampling (0.1), electric field direction, and type of electric field to DELTA:

```
% NLBands
  5 | 14 |                   # [NL] Bands
%
NLverbosity= "high"          # [NL] Verbosity level (low | high)
NLtime=55.000000      fs     # [NL] Simulation Time
NLintegrator= "CRANKNIC"     # [NL] Integrator ("EULEREXP/RK2/RK4/RK2EXP/HEUN/INVINT/CRANKNIC")
NLCorrelation= "SEX"         # [NL] Correlation ("IPA/HARTREE/TDDFT/LRC/LRW/JGM/SEX")
% NLEnRange
 0.100000 | 10.000000 | eV   # [NL] Energy range
%
NLEnSteps= 1                 # [NL] Energy steps
NLDamping= 0.000000    eV    # [NL] Damping
% ExtF_Dir
 0.000000 | 1.000000 | 0.000000 |# [NL ExtF] Versor
%
ExtF_kind= "DELTA"               # [NL ExtF] Kind(SIN|SOFTSIN|RES|ANTIRES|GAUSS|DELTA|QSSIN)
```

Add GW QP database:

```
GfnQPdb= "E < SAVE/ndb.QP"       # [EXTQP G] Database action
```

And add the parameters for parallel distribution:
```
NLogCPUs = 10                 # [PARALLEL] Live-timing CPU`s (0 for all)
PAR_def_mode= "workload"      # [PARALLEL] Default distribution mode ("balanced"/"memory"/"workload")
```

Submit the calculation for real time dynamics to calculate linear response (calc. time 1h30m):   

> sbatch [job_yambo_lr](Example_08/job_yambo_lr)  

Yambo_nl does not allow to calculate on more than 2 nodes because of nothing to parallelize.    

Note. If you need to resubmitt the calculation, you need to remove dipoles files:   
```
 > rm SAVE/*dipoles*   
 > rm SAVE/*kind*   
```


### Analyze results for LR   

Run

> ypp_nl -u   

and change energy range, DampMode and DampFactor:   
```
% EnRngeRt
  0.00000 | 10.00000 |         eV    # Energy range
DampMode= "LORENTZIAN"               # Damping type ( NONE | LORENTZIAN | GAUSSIAN )
DampFactor= 0.100000       eV        # Damping parameter
%
```

Then run   

> ypp_nl   

To plot &epsilon;(E)   

> gnuplot [plot_eps.gnu](Example_08/plot_eps.gnu)    

The result is [plot_eps.pdf](Example_08/plot_eps.pdf)    


### SHG with GW-TD BSE   

Copy yambo_lr.in file:   

> cp yambo_lr.in yambo_shg.in   

and change it:   

```
NLtime=-1.000000           fs    # [NL] Simulation Time
NLEnSteps= 200                     # [NL] Energy steps
NLDamping= 0.1500000        eV    # [NL] Damping (or dephasing)
Field1_kind= "SOFTSIN"           # [RT Field1] Kind(SIN|RES|ANTIRES|GAUSS|DELTA|QSSIN)
```

Run SHG calculation:

> sbatch [job_yambo_shg](Example_08/job_yambo_shg)   

calculation time on 10 nodes with 48 cores is 25h.    

If calculations were crashed, then you need to resubmit the job, Yambo will contin ue calculation from the interrupted point. 

### Analyze resulst for SHG   

Run

> ypp_nl -u   

and change energy range, DampMode and DampFactor:   
```
Xorder=  4                   # Max order of the response functions
% EnRngeRt
  0.00000 | 10.00000 | eV    # Energy range
DampMode= "NONE"             # Damping type ( NONE | LORENTZIAN | GAUSSIAN )
DampFactor=  0.10000   eV    # Damping parameter%
```

Then run   

> ypp_nl   

Then plot &chi;<sup>(2)</sup>(E)  

> gnuplot [plot_absX2.gnu](Example_08/plot_absX2.gnu)        

The result is plot_absX2.pdf


[Go to top](#yambo-usage)  

