#!/bin/bash
# wdir
OMP_NUM_THREADS=2
cd $wdir
#Energy minimization
>&2 echo 'Script running:***************************** 8. Energy minimization *********************************'
gmx grompp -f minim.mdp -c solv_ions.gro -p topol.top -n index.ndx -o em.tpr -maxwarn 1
gmx mdrun -v -deffnm em -s em.tpr

gmx energy -f em.edr -o potential.xvg <<< "Potential"


# NVT
>&2 echo 'Script running:***************************** 9. NVT *********************************'
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -n index.ndx -o nvt.tpr -maxwarn 1
gmx mdrun -deffnm nvt -s nvt.tpr

gmx energy -f nvt.edr -o temperature.xvg  <<< "Temperature"


# NPT
>&2 echo 'Script running:***************************** 10. NPT *********************************'
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -n index.ndx -o npt.tpr  -maxwarn 1
gmx mdrun -deffnm npt -s npt.tpr

gmx energy -f npt.edr -o pressure.xvg <<< "Pressure"
gmx energy -f npt.edr -o density.xvg <<< "Density"