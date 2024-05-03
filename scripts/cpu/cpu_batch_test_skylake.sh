#!/bin/bash

# Attempt to request a specific 

#SBATCH -p batch
#SBATCH -C skylake

# Ensures all allocated cores are on the same node
#SBATCH -N 1

# Request 1 CPU core
#SBATCH -n 1

#SBATCH -t 00:15:00
#SBATCH -o outputs/with_cpu_skylake-%j.out
#SBATCH -e outputs/with_cpu_skylake-%j.err

# Load CUDA module
echo "~~~ NATIVE ~~~";
julia -Cnative benchmark.jl CPU;

for cf in branchfusion cmov harden-sls-ijmp harden-sls-ret lvi-load-hardening macrofusion pad-short-functions sse; 
do 
	julia -Cnative,+$cf benchmark.jl CPU; 
done;
