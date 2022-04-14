# YAMBO usage

* [Yambo installation](https://github.com/Dmitry-Skachkov/Yambo_examples#yambo-installation-on-stokes-supercluster-of-ucf)  
* [Example 1. Ground state calculation](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/README.md#example-1)  
* [Example 2. GW band structure](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/README.md#example-2)  
* [Example 3. Optical properties](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/README.md#example-3)  
* [Example 4. Parallel calculation](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/README.md#example-4)


# Yambo installation on Stokes Supercluster of UCF

Copy Yambo code and unpack:  

> wget https://github.com/yambo-code/yambo/archive/refs/tags/5.0.4.zip  
> tar -xvf 5.0.4.zip

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

> ./configure --enable-memory-profile --enable-dp   
> make all  

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

Copy the executables into default directory:

> cp yambo/bin/* ~/bin/

Check yambo version:

> yambo -version

```
This is yambo - MPI+HDF5_IO - Ver. 5.0.4 Revision 19598 Hash 20b2ffa04
```

# Example 1

## Ground State Calculation as Starting Point for YAMBO

In this example we follow the recommendations from [https://www.paradim.org](https://www.paradim.org/toolbox/computation/tutorials)

The detailed description of the example is in the [pdf file](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_1/YAMBO_Tutorial-1_Ground_State_Calculation_as_Starting_Point_for_YAMBO.pdf)

### QE scf calculation

All input files are here [Example_1](https://github.com/Dmitry-Skachkov/Yambo_examples/tree/main/Example_1)

To run the example (calculation time is 3s):

> sbatch [job_QE](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_1/job_QE)

### Convertiong QE files to YAMBO

After the calculation it is necessary to convert QE files to Yambo format. The detailed notes about the conversion are [here](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_1/YAMBO_Tutorial-2_File_Conversion_from_QE_to_YAMBO.pdf).

> cd d.save  
> p2y  

The program *p2y* creates directory SAVE with converted files.  
To check the conversion:

> yambo  


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

The last command creates the file ypp.in, which is necessary to correct, insert the directory with quasi-particle correction and the k-pathway for plot. The corrected file [ypp.in](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/ypp.in)  

To interpolate the GW band structure:

> ypp  

The output of the ypp code is [o.bands_interpolated](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/o.bands_interpolated) with the data, which can be used to plot the band structure.  

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
 1    2    1    4    4    1m38s
 1    4    1    4    4    1m45s
 1    2    2    1    4    1m28s
 1    2    1    4    2    1m40s
 1    2    1    1    2    1m19s
 1    2    2    1    2    1m15s
```
The optimized running job script is [job_QE_2x48](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_4/job_QE_2x48) 

### Yambo GW on 10 nodes

Yambo code has several levels of paralelization. The parameters of paralelization are in input file *yambo.in*:

```
NLogCPUs = 10                               # [PARALLEL] Live-timing CPU`s (0 for all)
X_nCPU_LinAlg_INV=1                         # [PARALLEL] CPUs for Linear Algebra
DIP_CPU= "2 24 10"                          # [PARALLEL] CPUs for each role
DIP_ROLEs= "k c v"                          # [PARALLEL] CPUs roles (k,c,v)
SE_CPU= "1 10 48"                           # [PARALLEL] CPUs for each role
SE_ROLEs= "q qp b"                          # [PARALLEL] CPUs roles (q,qp,b)
X_Threads= 1                                # [OPENMP/X] Number of threads for response functions
DIP_Threads= 1                              # [OPENMP/X] Number of threads for dipoles
SE_Threads= 1                               # [OPENMP/GW] Number of threads for self-energy
```

The detailed description of these parameters is [here](http://www.yambo-code.org/wiki/index.php?title=GW_parallel_strategies)


