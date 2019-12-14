# tools for parse julia files

### Usage
#==
1) include("parsetool.jl") or using FuncTree
2) w=parsefile(file) or ww=parsefiles(filename's vector)
2.5) showtypes(w) show the type of first element of every lines
3) findcaller(w)  function/macro definitions
4) findcallee(w)  function call function
5) fullparse(w)   numbering findcallee()

==#

global JULIANAMES=[:GlobalRef, :(Meta.parse), :(core.@doc), :macrocall,
:if, :for, :while, :global, :block, :&&, :||,
:append!, :push!, :map, :isa, :println,:in,:all,
:length, :print, :println,
:+, :-, :*, :/, :!,
:(=),:(==), :(!=), :(>=), :(<=), :(<), :(>), :(:)
]

global PRIVATENAMES = []               # customize the ignored function names
# really ignore these names in findcallee()
global IGNORENAMES=vcat(JULIANAMES, PRIVATENAMES) 


# I don't use Otherwise. Any is enough in method definition.
# But I remain this for memory.

# GlobalRef in toplevel of a file
# LineNumberNode in Meta.parse()
# QuoteNode maybe in comment
# Number in as x = 2. :(=)'s second but not Expr
# Otherwise = Union{Char,Symbol,String,LineNumberNode,GlobalRef,QuoteNode,Number,Nothing}

#### 1. parse files

function readfile(fname)
 open(fname) do f
   read(f, String)
 end
end

function parsestr(str)
 ix=1
 ps=[]
 while true
   (pp, ni) = Meta.parse(str,ix)
   if pp==nothing; break end
   push!(ps, pp)
   ix=ni
 end
 return ps
end

function parsefile(fname)
 fs = readfile(fname)
 return parsestr(fs)
end

"parsefilesf use for looping on files"
function parsefilesf(fns)
  fs = []
  for afn in fns
    append!(fs, parsefile(afn))
  end
  return fs
end

"""
parsefiles parses julia files
"""
function parsefiles(fns)
  map(x->parsefile(x), fns)
end

## run
#pt=parsefile("parsetool.jl")


### collect caller
"""
 showtypes shows toplevel type of Array of something"
"""
function showtypes(es)
  map(x->(x isa Expr && x.head),es)
end


##### Array cases are all same
"""
finding function definitions from Array of something
"""
macro arrayfunc(name)
  :(function $name(ae::Array)
    somes = []
    for e in ae
      !(e isa Nothing) && append!(somes, $name(e))
    end
    return somes
  end)
end

"""
findcaller array case
"""

@arrayfunc(findcaller)

# problem
# f = g and g is a function
# z = something z is a variable
# now i ignore both as not a function

function findcaller(expr::Expr)
  if expr.head in [:macrocall]
    return findcaller(expr.args)
  elseif expr.head in [:macro]
    return [(:m, expr.args[1])]
  elseif expr.head in [:function, :call]
    return [(:f, expr.args[1])]
  elseif expr.head == :(=)
    if expr.args[1] isa Expr
      return [(:f, expr.args[1])]
    end
  end
  return []
end

function findcaller(something::Any)
  return []
end

### collect caller->callee
"""
findcalee return a Array of called functions from a expr
now, ignore macrocall
"""

@arrayfunc(findcalleetop)

function findcalleetop(something::Any)
  return []
end

function findcalleetop(expr::Expr)
  if expr.head in [:function, :(=)]
    caller = expr.args[1]
    callees = findcallee(expr.args[2])
    println("$caller => $callees")
    return [caller, callees] 
  elseif expr.head in [:call]
    caller = expr.args[1]
    callees = findcallee(expr.args[2:end])
    println("$caller => $callees")
    return [caller, callees] 
  elseif expr.head in [:macrocall]
    callinf = findcalleetop(expr.args)
    return callinf
  elseif expr.head in [:(.)]
    return []
  else
    return []
  end
end

"""
findcallee find callee in rhs
"""
function findcallee(expr::Expr)
  callees = []
  if expr.head in [:function, :call]
    push!(callees, expr.args[1])
    append!(callees, findcallee(expr.args[2:end]))
  elseif expr.head in [:return]
    append!(callees, findcallee(expr.args[1]))
  elseif expr.head == :(=)
    append!(callees, findcallee(expr.args[2]))
  elseif expr.head in JULIANAMES
    append!(callees, findcallee(expr.args))
  end
  return setdiff(callees, JULIANAMES)
end

"""
findcallee on otherwise
"""
function findcallee(something::Any)
  return []
end

"""
findcallee find callee in array of something
"""

@arrayfunc(findcallee)


### for multi julia files
function fullparse(exprs)
  for i in 1:length(exprs)
    ex = exprs[i]
    if ex isa Expr
      print("$i:"); findcalleetop(ex)
    else
      println("$i type is $(typeof(ex)) ")
    end
  end
end

function packparsed(expss)
  exps=[]
  map(x->append!(exps, x), expss)
  exps
end


