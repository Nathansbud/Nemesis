#!/bin/bash

# export JULIA_DEPOT_PATH=$(realpath envs/$SLURM_JOB_ID)
# echo $JULIA_DEPOT_PATH
make setup
julia benchmark.jl GPU
