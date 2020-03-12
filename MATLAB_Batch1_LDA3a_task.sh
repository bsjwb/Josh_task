#Project 1 MATLAB Script: Subjects 1-10

#Run with current set of modules and in the current directory
#$ -V -cwd

#Request some time- min 15 mins - max 48 hours
#$ -l h_rt=48:00:00

#Request some memory
#$ -l h_vmem=20G

#Get email at start and end of the job
#$ -m be
#$ -M bsjwb@leeds.ac.uk

# specify this is a task array
#$ -t 1-3

#Now run the job
module load matlab
#matlab --no-display --no-desktop < Separate_Runs_LDA_Approach3a.m
matlab -nodisplay -nodesktop -r "Separate_Runs_LDA_Approach2b($SGE_TASK_ID);exit"
