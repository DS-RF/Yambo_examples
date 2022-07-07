#!/bin/bash

rm o.bands_inter*  

NBND=$(( $2 - $1 + 1 ))                          # total number of bands for plotting
echo "NBND=$NBND"
NBS=$(( $NBND/10 ))                              # number of files
echo "NBS=$NBS"

if [ $(( NBND%10 )) != 0 ]; then 
 NBS=$(( $NBS + 1 ))  
fi
echo "NBS=$NBS"

for ((i=1;i<=$NBS;i++)); do  

# read bands by 10
echo $i
I1=$(( $1 + ($i-1)*10 ))
I2=$(( $1 + ($i-1)*10 + 9 ))
sed "s/ 1 |  99 |/ $I1 |  $I2 |/" $3 > ypp.in
ypp 
mv o.bands_interpolated $i

done


# combine files into bands_pl_yambo.dat
yambo_band_plot $1 $2 $3




## Example of usage:
## yambo_band_plot.sh 5 25 ypp_GW.in     - plot bands from 5 to 25 using ypp_GW.in input file   

