#!/bin/bash

module load julia
module load cuda
mkdir -p envs/$SLURM_JOB_ID
export JULIA_DEPOT_PATH=$(realpath envs/$SLURM_JOB_ID)
export JULIA_CUDA_USE_COMPAT=false
echo $JULIA_DEPOT_PATH
make setup || true
# make setup || true
cat benchmark.jl
julia benchmark.jl CPU
rm -rf envs/$SLURM_JOB_ID
