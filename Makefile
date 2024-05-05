setup:
	mkdir -p env
	julia -e 'using Pkg; Pkg.add(["Oceananigans", "BenchmarkTools", "CUDA"])'

benchmark-gpu:
	mkdir -p output
	rm -f output/$(GPU)-gpu.log || true
	sbatch --job-name="$(GPU)-gpu" --partition=gpu --gres=gpu:1 --nodes=1 --output=output/$(GPU)-gpu.log --mem=16G --time=01:00:00 -c 8 -C $(GPU) scripts/run-gpu.sh $(GPU)

benchmark-gpu-cpu:
	mkdir -p output
	rm -f output/$(GPU)-cpu.log || true
	sbatch --job-name="$(GPU)-gpu-cpu" --partition=gpu --gres=gpu:1 --nodes=1 --output=output/$(GPU)-gpu-cpu.log --mem=16G --time=01:00:00 -c 8 -C $(GPU) scripts/run-gpu-cpu.sh

benchmark-cpu:
	mkdir -p output
	rm -f output/$(CPU)-cpu.log || true
	sbatch --job-name="$(CPU)-cpu" --partition=batch --nodes=1 --output=output/$(CPU)-cpu.log --mem=16G --time=01:00:00 -c 8 -C $(CPU) scripts/run-cpu.sh $(CPU)

benchmark-gpus:
	make benchmark-gpu GPU="quadrortx"
	make benchmark-gpu GPU="geforce3090"
	make benchmark-gpu GPU="titanrtx"
	make benchmark-gpu GPU="a5000"
	make benchmark-gpu GPU="a5500"
	make benchmark-gpu-cpu GPU="a5000"

benchmark-cpus:
	make benchmark-cpu CPU="icelake"
	make benchmark-cpu CPU="cascade"
	make benchmark-cpu CPU="amd"
