#!/bin/bash

rm o.bands_inter*

# plot bands 1-10
sed -i "s/ 1 |  99 |/ 1 |  10 |/" ypp.in
ypp
mv o.bands_interpolated 1

# plot bands 11-20
sed -i "s/ 1 |  10 |/ 11 |  20 |/" ypp.in
ypp
mv o.bands_interpolated 2

# plot bands 21-30
sed -i "s/ 11 |  20 |/ 21 |  30 |/" ypp.in
ypp
mv o.bands_interpolated 3

# combine files 1, 2, 3 into bands_pl_yambo.dat
yambo_band_plot

sed -i "s/ 21 |  30 |/ 1 |  99 |/" ypp.in

