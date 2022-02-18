module FujitsuBLAS

import Libdl: find_library, dlopen, RTLD_GLOBAL
import LinearAlgebra.BLAS

function __init__()
    if "LD_LIBRARY_PATH" in keys(ENV)
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
        isempty(libfjlapackexsve_ilp64) && return Cint(0)
        return BLAS.lbt_forward(libfjlapackexsve_ilp64; clear=true)
    end
    return Cint(0)
end

end # module
