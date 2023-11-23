module FujitsuBLAS

import Libdl: find_library, dlopen, dllist, RTLD_GLOBAL
import LinearAlgebra.BLAS
using Scratch

const _libdummy = joinpath(@get_scratch!("libdummy"), "libdummy.so")

function __init__()
    if "LD_LIBRARY_PATH" in keys(ENV)
        if isfile(_libdummy)
            # HACK TIME! Try to load an empty library which automatically loads
            # Fujitsu BLAS and also initialises the OpenMP runtime, so that we
            # can run multi-threaded BLAS calls.
            dlopen(_libdummy)
            libs = filter(contains("libfjlapackexsve_ilp64"), dllist())
            libfjlapackexsve_ilp64 = isone(length(libs)) ? only(libs) : ""
        else
            # If the dummy library doesn't exist because, for example,
            # compilation failed, try to load the individual libraries we need
            # one by one, but note that this time BLAS calls won't be
            # multi-threaded.
            library_path = split(ENV["LD_LIBRARY_PATH"], ':')
            # Needed for symbol `__jwe_x_init`
            libfj90i = find_library("libfj90i.so", library_path)
            isempty(libfj90i) && return Cint(0)
            dlopen(libfj90i, RTLD_GLOBAL)
            # Needed for symbol `__g_dscn2`
            libfj90f = find_library("libfj90f.so", library_path)
            isempty(libfj90f) && return Cint(0)
            dlopen(libfj90f, RTLD_GLOBAL)
            # OpenMP
            libfjomp = find_library("libfjomp.so", library_path)
            isempty(libfjomp) && return Cint(0)
            dlopen(libfjomp, RTLD_GLOBAL)
            # And finally, Fujitsu BLAS
            libfjlapackexsve_ilp64 = find_library("libfjlapackexsve_ilp64.so", library_path)
        end
        isempty(libfjlapackexsve_ilp64) && return Cint(0)
        return BLAS.lbt_forward(libfjlapackexsve_ilp64; clear=true)
    end
    return Cint(0)
end

end # module
