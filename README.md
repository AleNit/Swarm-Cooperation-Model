# Swarm-Cooperation-Model (SCM)
Hybrid meta-heuristic optimizer for the decentralized control of an agent swarm. It can be used both as optimization tool or as controller for autonomous vehicles, on steady and unsteady, multimodal landscapes.

# Developers
Alessandro Nitti, Polytechnic University of Bari (https://scholar.google.it/citations?user=lv1V6-4AAAAJ&hl=it&oi=ao)  

# Dependencies
All of the script are Matlab files, with ".m" extension. The necessary MATLAB toolboxes are 
"Symbolic Math Toolbox", "Statistics and Machine Learning Toolbox", "Optimization Toolbox", "Global Optimization Toolbox". 

# Methodology
Details about the methodology and numerical implementation can be found in the following paper:  
Nitti A., de Tullio M.D., Federico I., Carbone G., "A collective intelligence approach to real-world swarm robotics", (2025).

# Organization of the repository
All files are provided with a docstring explaining purpose, input and output of the function.  
./SCM_steady/: contains the Matlab scripts used to run optimization problems. All the main programs have prefix <MAIN_>.  
./utils/: contains the utility routines called in the main programs.
