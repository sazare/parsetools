
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

@show :parsefiles
@time clexps =parsefiles(files)
@show :parsefilesf
@time clexpsf=parsefilesf(files)


cd(here)

#showexprs(clexps)
#showexprs(clexpsf)

#==
for i in 1:313
  if clexps[i] isa Expr
    println("$i:$(clexps[i].head)")
  else
    println("$i type is $(typeof(clexps[i])) // clexps[i])")
  end
end
==#

#==
sss=[]
map(x->append!(sss, x), clexps)
fullparse(sss)

#findcalleetop(sss)
==#

