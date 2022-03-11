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

In this example we follow the recommendations from https://www.paradim.org/toolbox/computation/tutorials

The detailed description of the example is in the file [YAMBO_Tutorial-1_Ground_State_Calculation_as_Starting_Point_for_YAMBO.pdf](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_1/YAMBO_Tutorial-1_Ground_State_Calculation_as_Starting_Point_for_YAMBO.pdf)

All input files are here [Example_1](https://github.com/Dmitry-Skachkov/Yambo_examples/tree/main/Example_1)

To run the example (calculation time is 3s):

> sbatch [job_QE](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_1/job_QE)

After the calculation it is necessary to convert QE files to Yambo format. The detailed notes about the conversion are [here](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_1/YAMBO_Tutorial-2_File_Conversion_from_QE_to_YAMBO.pdf).

> cd d.save  
> p2y  

The program *p2y* creates directory SAVE with converted files.  
To check the conversion:

> yambo  


# Example 2

## GW Band Structure with YAMBO

In order to create the input file for GW calculation:

> yambo -x -g n -p p  
> mv yambo.in yambo1.in  

The detailed description of the example is here [YAMBO_Tutorial-3.1_GW_Band_Structure.pdf](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/YAMBO_Tutorial-3.1_GW_Band_Structure.pdf)

To run the GW calculation (calculation time is 3m):

> sbatch job_yambo  

The yambo output with GW calculation is here [r_HF_and_locXC_gw0_dyson_em1d_ppa_01](https://github.com/Dmitry-Skachkov/Yambo_examples/blob/main/Example_2/r_HF_and_locXC_gw0_dyson_em1d_ppa_01) 
