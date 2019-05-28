#!/bin/bash
# Purpose:    Make a 3-D bar histogram plot (here: Kuril-Kamchatka Trench)
# GMT modules: gmtset, grd2xyz, gmtinfo, pstext, psxyz, logo, psconvert
# Unix progs: echo
#
# Step-1. GMT set up
gmt set
    MAP_TITLE_OFFSET 0.8c \
    MAP_ANNOT_OFFSET 0.2c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_CROSS_PEN thinnest,dimgray \
    MAP_GRID_CROSS_PEN thinnest,dimgray \
    MAP_GRID_PEN thinnest,dimgray \
    FONT_TITLE 8p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 9p,Palatino-Roman,dimgray \
    FONT_LABEL 8p,Palatino-Roman,dimgray \
# Step-2. Generate a file
ps=Hist3DKKT.ps
# Step-3. Convert grid file to data table
gmt grd2xyz kkt_bathy.nc > kkt_bathy.xyz
# Step-4. Check up depth/heights range
gmt info kkt_bathy.xyz
#kkt_bathy.xyz: N = 87001    <140/170>    <40/60>    <-9317/3319>
# Step-5. Plot 3D histogram from the data table
gmt psxyz kkt_bathy.xyz -Bpxa2 -Bpya1 -Bsxg2a2 -Bsyg1a1 -Bz1000+l"Bathymetry and topography (m)" \
    -BWSneZ+b+t"3D-histograms of the depth values: Kuril-Kamchatka Trench" \
    -R144/162/40/50/-7600/2000 -JM10c -JZ7c -p215/30 -So0.083ub-6000 -P \
    -Wthinnest -Glavenderblush  -UBL/-15p/-35p -K > $ps
# Step-6. Add subtitle
gmt pstext -R0/10/0/10 -JX10/10 -X0.0c -Y0.0c \
    -F+f9p,Palatino-Roman,black+jLB -N -O -K >> $ps << EOF
0.0 12.2 View azimuth from the southwest (215\232) at 30\232 elevation
EOF
#
echo '7.5 0.0 Input data: ETOPO5 grid converted to XYZ ASCII' | gmt pstext -R0/10/0/10 -JX10/10 -X0.0c -Y0.0c \
    -F+f8p,Palatino-Roman+jLB+a19 -N -O -K >> $ps
# Step-7. Add GMT logo
gmt logo -Dx6.0/0.0+o-0.5c/-1.5c+w2c -O >> $ps
# Step-8. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert Hist3DKKT.ps -A0.2c -E720 -Tj -P -Z
# Quick variant:
#gmt grd2xyz kkt_bathy.nc | gmt psxyz -B1 -Bz1000+l"Topography (m)" -BWSneZ+b+tETOPO5 \
#   -R140/170/40/60/-9400/3400 -JM5i -JZ6i -p200/30 -So0.0833333ub-5000 -P \
#    -Wthinnest -Glightgreen -K > $ps
