# LiBrGUI

All the inputs refer to lithium bromide and water liquid solution's properties.

## How to run

> [!IMPORTANT]  
> Before starting the project please be sure to have Julia installed on you PC!

On project folder run the following cmd commands 

```
julia --project=.
```

and then 

```
using Pkg
Pkg.activate(".")
Pkg.instantiate()
exit()
```

Congrats, you have now dowloaded all libraries and dependencies required to run the code!

While being in the same directory as `main.jl`, you can now run the program by cmd typing

```
julia --project=. main.jl
```

If a `__precompile__` error occours then seek for `XStream.jl` file and add as first line the following instruction:

```
__precompile__(false)
```