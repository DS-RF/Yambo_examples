 set term postscript enh color font 'Times-Roman,18'
 set output 'plot_absX2.ps'
 set multiplot
 plot "o.YPP-X_probe_order_2" using  1:(sqrt($2**2+$3**2))  with lines lc  3  lt  2  lw 2 title "Abs X(2) xxx"
 unset multiplot
