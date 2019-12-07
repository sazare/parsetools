# tools for parse julia files

### RESTRICTION 
#==
1. function definition in function definition. in this case
   find just inside funtion name.
2. f=g and g is a function. I don't follow g's def as f's def.
3. i don't follow macro definition as this file.
==#

### between document string and function should have a blank line
### or, the comment and 1st line in a single token

global JULIANAMES=[:GlobalRef, :(Meta.parse),
:if, :for, :while, :global, :block, :&&, :||,
:append!, :push!, :map, :isa, :println,:in,
:+, :-, :*, :/,
:(=),:(==), :(!=), :(>=), :(<=), :(<), :(>)
]

global PRIVATENAMES = []
global IGNORENAMES=vcat(JULIANAMES, PRIVATENAMES)

# GlobalRef in toplevel of a file
# LineNumberNode in Meta.parse()
# QuoteNode maybe in comment
# Number in as x = 2. :(=)'s second but not Expr

Otherwise = Union{Symbol,String,LineNumberNode,GlobalRef,QuoteNode,Number}

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


##### collect callee

"""
finding function definitions from Array of something
"""

macro arrayfunc(name)
  :(function $name(ae::Array)
    somes = []
    for e in ae
      append!(somes, $name(e))
    end
    return somes
  end)
end

@arrayfunc(findcaller)

#==
function findcaller(ae::Array)
  callers=[]
  map(e->append!(callers,findcaller(e)),ae)
  return callers
end
==#

function findcaller(something::Otherwise)
  return []
end

# problem
# f = g and g is a function
# z = something z is a variable
# now i ignore both as not a function

function findcaller(expr::Expr)
  if expr.head in [:function, :call]
    return [expr.args[1]]
  elseif expr.head == :(=)
    if expr.args[1] isa Expr
      return [expr.args[1]]
    end
  else
    return []
  end
end

### collect caller->callee
"""
findcalee return a Array of called functions from a expr
now, ignore macrocall
"""

# finding callee

@arrayfunc(findcalleetop)

#==
function findcalleetop(ae::Array)
  callees=[]
  for e in ae
    append!(callees,findcalleetop(e))
#    e isa Expr && append!(callees,findcalleetop(e))
  end
  return callees
end
==#

function findcalleetop(something::Otherwise)
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

function findcallee(something::Otherwise)
  return []
end

"""
findcallee find callee in array of something
"""

@arrayfunc(findcallee)

#==
function findcallee(ae::Array)
  callees=[]
  for e in ae
    append!(callees, findcallee(e))
  end
  return callees
end
==#

