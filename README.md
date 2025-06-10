# Swarm-Cooperation-Model (SCM)
Hybrid meta-heuristic optimization algorithm. It works as optimizer for bounded, non-convex problems or as decentralized controller for autonomous vehicles. Inspired to swarm intelligence phenomena.  

# Developers
Alessandro Nitti, Polytechnic University of Bari (https://scholar.google.it/citations?user=lv1V6-4AAAAJ&hl=it&oi=ao)  

# Dependencies
All of the script are Matlab files, with ".m" extension. The necessary MATLAB toolboxes are 
"Symbolic Math Toolbox", "Statistics and Machine Learning Toolbox", "Optimization Toolbox", "Global Optimization Toolbox". 

# Methodology
Details about the methodology and numerical implementation can be found in the following paper:  
Nitti A., de Tullio M.D., Federico I., Carbone G., "A collective intelligence model for swarm robotics applications", Nature Communications (2025).

# Organization of the repository
All files are provided with a docstring explaining purpose, input and output of the function. The purpose of the main executables is reported below:  

./SCM/: contains the Matlab scripts used to run optimization problems. All the main programs have prefix <MAIN_>.  
./SCM/MAIN_SCM.m: simulates the operation of the Swarm Cooperation Model (SCM) by integrating an overdamped Langevin equation. The objective of the swarm is to find the absolute minimum of the assigned landscape function.   
./SCM/MAIN_SCM_replications.m: runs the NNr replications of the SCM search over a test landscape function for performance comparison; evaluate success rate and mean number of function evaluations   
./SCM/MAIN_SCM_replications_par.m: runs NNr replications of the SCM over one landscape function to assess the influence of the hyperparameters: {omega,tau,sigma0}   
./utils/: contains the utility routines called in the main programs. 
