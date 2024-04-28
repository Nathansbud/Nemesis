using BenchmarkTools
using Oceananigans
using CUDA

macro sync_gpu(expr)
    return CUDA.has_cuda() ? :($(esc(CUDA.@sync expr))) : :($(esc(expr)))
end

function benchmark_func(Arch, N)
    grid = RectilinearGrid(Arch(); size=(N, N, N), extent=(1, 1, 1))
    model = NonhydrostaticModel(grid=grid)

    time_step!(model, 1) # warmup

    trial = @benchmark begin
        time_step!($model, 1)
    end samples = 10

    return trial
end

function pretty_print_trial(trial)
    println("Benchmark Results:")
    println("==================")
    println("Minimum time: $(minimum(trial.times) / 1e6) ms")
    println("Median time: $(median(trial.times) / 1e6) ms")
    println("Mean time: $(mean(trial.times) / 1e6) ms")
    println("Maximum time: $(maximum(trial.times) / 1e6) ms")
    println("Number of samples: $(length(trial.times))")
    println("Memory allocation: $(trial.memory) bytes")
    println("Allocations: $(trial.allocs)")
end


arch = length(ARGS) >= 1 && ARGS[1] == "GPU" && CUDA.has_cuda() ? GPU : CPU
println(arch)
trial = benchmark_func(arch, 256)
pretty_print_trial(trial)
