
here=pwd()
cd("/Users/shin/Projects/github/cheaplogic/Prover")

files = ["config.jl",
"utils.jl",
"misc.jl",
"types.jl",
"primitives.jl",
"common.jl",
"subst.jl",
"unifybase.jl",
"unify.jl",
"reso.jl",
"newcore.jl",
"coreprint.jl",
"corestring.jl",
"dvcreso.jl",
"analyzer.jl",
"repl.jl",
"merge.jl",
"parser.jl"
]

clexps=parsefiles(files)
println("clexps")

cd(here)

for i in 1:313
  if clexps[i] isa Expr
    println("$i:$(clexps[i].head)")
  else
    println("$i type is $(typeof(clexps[i])) // clexps[i])")
  end
end

