 set term postscript enh color font 'Times-Roman,18'
 set output 'plot_eps.ps'
 set multiplot
 plot "o.YPP-eps_along_E" using  1:2  with lines lc  3  lt  2  lw 4 title "Im eps", \
      "o.YPP-eps_along_E" using  1:5  with lines lc  5  lt  2  lw 4 title "Re eps"
 unset multiplot
