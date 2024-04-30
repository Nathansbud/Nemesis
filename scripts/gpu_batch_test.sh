#!/bin/bash

# Request a GPU partition node and access to 1 GPU
#SBATCH -p gpu --gres=gpu:1 --gres-flags=enforce-binding
#SBATCH -C geforce3090

# Ensures all allocated cores are on the same node
#SBATCH -N 1

# Request 1 CPU core
#SBATCH -n 1

#SBATCH -t 00:15:00
#SBATCH -o outputs/with_gpu.out
#SBATCH -e outputs/with_gpu.err

# Load CUDA module
module load cuda

nvidia-smi

# nvidia-smi --query-gpu=power.draw --format=csv --loop=1 > power_usage_base.log &
# nvidia-smi dmon -s p  > power_usage_dmon.log &

while true; do
    timestamp=$(date +"%Y-%m-%d %T.%N")
    power_draw=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits | tail -n 1)
    echo "$timestamp, $power_draw" >> outputs/logs/power_usage_while_logged.log
    sleep 0.1  # 100ms delay
done &

julia ocean_test_1_gpu.jl

# julia ocean_test_1_gpu.jl

# ncu -o outputs/profile julia ocean_test_1_gpu.jl

# nvprof --metrics power.draw julia ocean_test_1_gpu.jl

# Compile CUDA program and run
# nvcc -O2 experiments.cu 
# Profile
# nsys profile --stats=true --gpu-metrics-device=all --force-overwrite=true --output=outputs/gpu_report_2 julia ocean_test_1_gpu.jl
