setup:
	module load julia || true
	module load cuda || true
	julia -e 'using Pkg; Pkg.add(["Oceananigans", "BenchmarkTools", "CUDA"])'

benchmark-gpu:
	mkdir -p output
	rm -f output/$(GPU)-gpu.log || true
	sbatch --job-name="$(GPU)-gpu" --partition=gpu --nodes=1 --output=output/$(GPU)-gpu.log --mem=32G --time=01:00:00 -c 4 -C $(GPU) scripts/run-gpu.sh

benchmark-gpus:
	make benchmark-gpu GPU="quadrortx"
	make benchmark-gpu GPU="geforce3090"
	make benchmark-gpu GPU="titanrtx"
	make benchmark-gpu GPU="a5000"
	make benchmark-gpu GPU="a5500"
