credits to https://github.com/hzgzh/LiBr.jl

before starting the project please be sure to have Julia installed on you PC!

on project folder run the following cmd commands 

```
julia --project=.
```

Julia interpreter will open up. Then digit 

```
using Pkg
Pkg.activate(".")
Pkg.instantiate()
exit()
```

you have now dowloaded all libraries and dependencies required to run the code!

While being in the same directory as `main.jl`, you can now run the program by cmd typing

```
julia --project=. main.jl
```

if `__precompile__` error occours then seek for `XStream.jl` file and add as first line the following instruction:

```
__precompile__(false)
```
