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

nvidia-smi

while true; do
    timestamp=$(date +"%Y-%m-%d %T.%N")
    power_draw=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits | tail -n 1)
    echo "$timestamp, $power_draw" >> outputs/logs/"$1"-"$SLURM_JOB_ID".log
    sleep 0.1  # 100ms delay
done &

julia benchmark.jl GPU
rm -rf envs/$SLURM_JOB_ID
