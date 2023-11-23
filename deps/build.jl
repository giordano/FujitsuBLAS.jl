using UUIDs
using Scratch

const _libdummy = joinpath(get_scratch!(UUID("32aa7d10-2208-4269-9553-8a2b02007e37"), "libdummy"), "libdummy.so")

# Build a dummy library which automatically initalises the OpenMP runtime.
if !isnothing(Sys.which("fcc"))
    mkpath(dirname(_libdummy))
    run(pipeline(`fcc -Nclang -x c - -Kopenmp -shared -lfjlapackexsve_ilp64 -o $(_libdummy)`; stdin=IOBuffer("")))
end
