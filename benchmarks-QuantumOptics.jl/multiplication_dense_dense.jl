using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

srand(0)

name = "multiplication_dense_dense"

samples = 5
evals = 100
cutoffs = [50:50:601;]

function setup(N)
    b = GenericBasis(N)
    op1 = randoperator(b)
    op2 = randoperator(b)
    result = DenseOperator(b)
    op1, op2, result
end

function f(op1, op2, result)
    operators.gemm!(Complex128(1., 0.), op1, op2, Complex128(0., 0.), result)
end

println("Benchmarking: ", name)
print("Cutoff: ")
results = []
for N in cutoffs
    print(N, " ")
    op1, op2, result = setup(N)
    t = @belapsed f($op1, $op2, $result) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)