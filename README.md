# YAMBO usage

* [Yambo installation](#yambo-installation-on-stokes-supercluster-of-ucf)    
    * [Automatic installation of version 5.0.4](#automatic-installation-of-version-504)
    * [Separate compilation of libraries](#separate-compilation-of-libraries)
    * [Compilation version 5.1.1](#compilation-version-511)   
* [Example 1. Ground state calculation](#example-1)  
* [Example 2. GW band structure](#example-2)  
* [Example 3. Optical properties](#example-3)  
* [Example 4. Parallel calculation](#example-4)
* [Example 5. Linear response with IPA approximation](#example-5)
* [Example 6. Second harmonic generation with IPA approximation](#example-6)
* [Example 7. Linear response with time-dependent BSE](#example-7)

# Yambo installation on [Stokes Supercluster of UCF](https://arcc.ist.ucf.edu)   

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

The detailed description of the example is in the [pdf file](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_1/YAMBO_Tutorial-1_Ground_State_Calculation_as_Starting_Point_for_YAMBO.pdf)

### QE scf calculation

All input files are here [Example_1](https://github.com/Dmitry-Skachkov/Yambo_examples/tree/main/Example_1)

To run the example (calculation time is 3s):

> sbatch [job_QE](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_1/job_QE)

### Converting QE files to YAMBO

After the calculation it is necessary to convert QE files to Yambo format. The detailed notes about the conversion are [here](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_1/YAMBO_Tutorial-2_File_Conversion_from_QE_to_YAMBO.pdf).

> cd d.save  
> p2y  

The program *p2y* creates directory SAVE with converted files.  
To check the conversion:

> yambo  

[Go to top](#yambo-usage)

# Example 2

## GW Band Structure with YAMBO

### Run GW

This example is taken from [https://www.paradim.org](https://www.paradim.org/toolbox/computation/tutorials)   

In order to run this example it is necessary to run Example 1 at first and convert QE results to Yambo format. 

The directory with the example [Example_2](https://github.com/Dmitry-Skachkov/Yambo_examples/tree/main/Example_2)  
In order to create the input file for GW calculation:

> yambo -x -g n -p p  
> mv yambo.in yambo1.in  

The detailed description of the example is [here](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/YAMBO_Tutorial-3.1_GW_Band_Structure.pdf)

To run the GW calculation (calculation time is 3m):

> sbatch [job_yambo](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/job_yambo)  

The yambo output with GW calculation is here [r_HF_and_locXC_gw0_dyson_em1d_ppa_01](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/r_HF_and_locXC_gw0_dyson_em1d_ppa_01)  

### Plot Band Structure 

How to plot band structure [YAMBO_Tutorial-3.2_Postprocessing_of_the_quasiparticle_energies_to_obtain_the_GW_band_structure.pdf](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/YAMBO_Tutorial-3.2_Postprocessing_of_the_quasiparticle_energies_to_obtain_the_GW_band_structure.pdf)  

Generate input file for post-processing program *ypp*  
> ypp -s b 

Remove symmetry (the directory FixSymm will be created):

> ypp -y  

Correct input file by uncomment **RmTimeRev**.

> ypp  
> cd FixSymm  
> yambo  
> ypp -s b -V qp    

The last command creates the file ypp.in, which is necessary to correct.   

Change interpolation to BOLTZ in order to have smooth band curves:   

> INTERP_mode= "BOLTZ"                # Interpolation mode (NN=nearest point, BOLTZ=boltztrap aproach)

Select 10 bands for plotting:    

> % BANDS_bands     
>    01 |  99 |                         # Number of bands     
>

Change number of divisions for plotting:     

> BANDS_steps= 20                  # Number of divisions     

Add QP database: 

> GfnQPdb= "E < SAVE/ndb.QP"                  # [EXTQP G] Database action

Insert the k-points path:   

> %BANDS_kpts                      # K points of the bands circuit     
> 0.00000 |0.000000 |0.00000 |     
> 0.66666 |-0.33333 |0.00000 |     
> 0.50000 |0.000000 |0.00000 |     
> 0.00000 |0.000000 |0.00000 |     
> %     


The corrected file [ypp.in](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/ypp.in)  

To interpolate the GW band structure:

> ypp  

The output of the ypp code is [o.bands_interpolated](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/o.bands_interpolated) with the data, which can be used to plot the band structure.  

Run the script yambo_band_plot.sh:   
```
#!/bin/bash

rm o.bands_inter*

# plot bands 1-10
sed -i "s/   01 |  99 |/   01 |  10 |/" ypp.in
~/bin/yambo_5.0.4_dp/ypp
mv o.bands_interpolated 1

# plot bands 11-20
sed -i "s/   01 |  10 |/   11 |  20 |/" ypp.in
~/bin/yambo_5.0.4_dp/ypp
mv o.bands_interpolated 2

# plot bands 21-30
sed -i "s/   11 |  20 |/   21 |  30 |/" ypp.in
~/bin/yambo_5.0.4_dp/ypp
mv o.bands_interpolated 3

# combine files 1, 2, 3 into bands_pl_yambo.dat
yambo_band_plot
```

The band structure will be in the file bands_pl_yambo.dat.


[Go to top](#yambo-usage)

# Example 3

## Calculation of Optical Properties with YAMBO

The detailed description of the example [YAMBO_Tutorial-4_Calculation_of_Optical_Properties_with_YAMBO.pdf](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_3/YAMBO_Tutorial-4_Calculation_of_Optical_Properties_with_YAMBO.pdf)   

This example is taken from [https://www.paradim.org](https://www.paradim.org/toolbox/computation/tutorials)  

In order to run this example it is necessary to run Example 1 at first and convert QE results to Yambo format. 

To generate the input file for the GW-BSE calculation:

> yambo -o b -k sex -y h  
> mv yambo.in yambo2.in  

To correct *yambo2.in* file to insert QP correction:

> KfnQPdb= "E < SAVE/ndb.QP" # [EXTQP BSK BSS] Database 

The corrected file [yambo2.in](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_3/yambo2.in)  

To run the GW-BSE calculation (calculation time is 16m):

> sbatch [job_yambo](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_3/job_yambo)  

The results of GW-BSE calculation is in the file [r_optics_dipoles_bss_bse_em1d_ppa](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_3/r_optics_dipoles_bss_bse_em1d_ppa) with the results in file [o.eps_q1_haydock_bse](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_3/o.eps_q1_haydock_bse), EPS-Im versus E.   

[Go to top](#yambo-usage)

# Example 4  

## YAMBO parallel calculation on several nodes

### QE on 2 nodes

QE has several levels of parallelization. The parallelization scheme can be manipulated by 5 input parameters in calling pw.x program:    

> mpirun -np $PPN pw.x -ni 1 -nk 2 -nt 2 -nd 1 -nb 2 -input scf.in   

For detailed description see https://www.quantum-espresso.org/Doc/user_guide/node20.html The default values are equal to 1.     

Here are the test results for calculation time running QE on 2 nodes with 48 cores on Stokes supercluster of UCF:   

```
 ni  nk   nt   nd   nb   t_calc.
 1    1    1    1    1    2m32s
 1    1    1    4    1    3m13s
 1    1    1   16    1    5m32s
 1    2    2   16    2    5m59s
 1    2    1   16    2    3m41s
 1    2    2    1    8    2m34s
 1    4    1    4    4    1m45s
 1    2    1    4    2    1m40s
 1    2    1    4    4    1m38s
 1    2    2    1    4    1m28s
 1    2    1    1    2    1m19s
 1    2    2    1    2    1m15s      <-- optimized
```
The optimized running job script for 2 nodes is [job_QE_2x48](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_4/job_QE_2x48)    
Please note that optimized parameters depend on particular compiled version of QE (including scalapack or not) and particular system. Please also note, that for nscf calculation the optimized parameters will be different than for scf.    
For larger number of nodes, probably, the optimized parameters for parallelization will involve hybrid MPI/OpenMP scheme.

### Yambo GW on 10 nodes

Yambo code has several levels of paralelization. The parameters for paralelization can be placed in input file [yambo.in](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_4/yambo1.in). In order to generate parameters for paralelization you should use option *-V par*:

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
The job running script for 1 OpenMP thread [job_yambo_10x48_1](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_4/job_yambo_10x48_1)   
The job running script for 2 OpenMP threads [job_yambo_10x48_2](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_4/job_yambo_10x48_2)   
The job running script for 4 OpenMP threads [job_yambo_10x48_4](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_4/job_yambo_10x48_4)   

Please note, that in order to use hybrid OpenMP/MPI calculation you need to have hybrid OpenMP/MPI compiled version of Yambo, and in order to use parallel calculation for linear algebra (X_nCPU_LinAlg_INV=480) you need to compile Yambo with [ScaLapack library](http://www.netlib.org/scalapack/). 

[Go to top](#yambo-usage)

# Example 5  

## Linear responce 

This example is from [Lumen web-site](http://www.attaccalite.com/lumen/linear_response.html) 

### Setup calculation

At first, you need to do QE calculation ([scf](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_5/) and [nscf](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_5/)) and convert the data files to Yambo format (see [Example 1](#example-1)). SAVE directory will contain the following files:
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

> yambo_nl -u -F input_lr.in -V par    

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

File [o.polarization_F1](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_5/o.polarization_F1) will contain the polarization. 
   
[Go to top](#yambo-usage)

# Example 6  

## Second harmonic generation (SHG) 

This example is from Lumen web-site [SHG](http://www.attaccalite.com/lumen/shg_in_AlAs.html) and [Correlation and SHG](http://www.attaccalite.com/lumen/correlation_and_shg.html)   

Do [Example 5](#example-5) **Setup calculation**, and then generate input file for second harmonic calculation:

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
The modified input file [yambo_shg.in](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_6/yambo_shg.in)

Submit job on 48 cores for real-time dynamics (calc. time 40m7s):   

> sbatch [job_yambo_nl](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_6/job_yambo_nl)   


[Go to top](#yambo-usage)     


# Example 7   

## Linear response with time-dependent BSE   

Following [Lumen web-site](http://www.attaccalite.com/lumen/real_time_bse.html)

Do [Example 5](#example-5) **Setup calculation** at first and do initialization of non-linear calculation:

> yambo_nl -F setup.in   

Generate input file for collisions calculation:

> yambo_nl -d s -e -v h+sex   

and reduce the parameters of calculation:

```
% COLLBands
   4 |  5 |                   # [COLL] Bands for the collisions
%
```   
Here 4 is the VBM and 5 is CBM orbitals.


[Go to top](#yambo-usage)  


