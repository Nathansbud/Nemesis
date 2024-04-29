println("Importing BenchmarkTools")
using BenchmarkTools
println("Importing Oceananigans")
using Oceananigans
println("Importing CUDA")
using CUDA

macro sync_gpu(expr)
    return CUDA.has_cuda() ? :($(esc(CUDA.@sync expr))) : :($(esc(expr)))
end

function benchmark_func(Arch, N)
    grid = RectilinearGrid(Arch(); size=(N, N, N), extent=(1, 1, 1))
    model = NonhydrostaticModel(grid=grid)

    time_step!(model, 1) # warmup

    trial = @benchmark begin
        @sync_gpu time_step!($model, 1)
    end samples = 10

    return trial
end

arch = length(ARGS) >= 1 && ARGS[1] == "GPU" && CUDA.has_cuda() ? GPU : CPU
println(arch)
trial = benchmark_func(arch, 256)
display(trial)
