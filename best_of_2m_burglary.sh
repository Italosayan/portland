#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_best_of.log
#$ -e /home/chiricom/portland/error_best_of.log

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0
#see http://stackoverflow.com/questions/6395078/
unset R_HOME

sh fit_features.bash 600 425 0 3.5 4.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 600 600 0 3 2 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 600 425 0 2 6 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 600 425 0 2 5.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 600 425 0 3.5 5.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 600 250 0 1 4.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 600 250 0 1 5.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 425 0 3.5 2.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 600 600 0 3 1 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 600 600 0 3 3 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 2 6 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 2 3 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 2 5.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 1 2 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 3 2 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 1 6 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 1 5.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 2 4.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 6 5.5 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
sh fit_features.bash 250 250 0 3 6 200 1e-05 1e-04 0.5 1 0 0.5 1000 7 6 2m burglary
