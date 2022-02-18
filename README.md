# FujitsuBLAS.jl

This package makes it possible to use Fujitsu BLAS in Julia, on
[Fugaku](https://www.r-ccs.riken.jp/en/fugaku/) and other systems using [Fujitsu
A64FX](https://en.wikipedia.org/wiki/Fujitsu_A64FX) CPUs, by leveraging
[libblastrampoline](https://github.com/JuliaLinearAlgebra/libblastrampoline).

## Installation

To install `FujitsuBLAS.jl`, activate the Pkg mode in the Julia REPL by typing the `]` key and run

```
add https://github.com/giordano/FujitsuBLAS.jl
```

`FujitsuBLAS.jl` is available for Julia v1.7 and following releases.

## Usage

When loading the package, make sure that the libraries provided by Fujitsu Development
Studio are in a directory listed in the `LD_LIBRARY_PATH` environment variable, because
`FujitsuBLAS.jl` will try to use the first libraries called

* `libfj90i.so`
* `libfj90f.so`
* `libfjomp.so`
* `libfjlapackexsve_ilp64.so`

that it will find in those directories.

After installation, you can start using Fujitsu BLAS for your operations in
`LinearAlgebra` with

```julia
using FujitsuBLAS
```

That's it.

## License

`FujitsuBLAS.jl` is released under the terms of the MIT "Expat" License.  The original author is
Mosè Giordano.
