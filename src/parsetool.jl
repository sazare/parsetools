
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

ss=parsefile("parsetool.jl")

function parsefilesf(fns)
  fs = []
  for afn in fns
    append!(fs, parsefile(afn))
  end
  return fs
end

function parsefiles(fns)
  map(x->parsefile(x), fns)
end

function showexprs(es)
  for i in 1:length(es)
    if clexps[i] isa Expr
      println("$i:$(clexps[i].head)")
    else
      println("$i type is $(typeof(clexps[i])) // clexps[i])")
    end
  end
end

#####
# finding caller
function findcallerinargs(args)
  callee = []
  for arg in args
    if arg isa Expr
@show arg
      append!(callee,findcallerinexpr(arg))
    end
  end
  return callee
end


function findcallerinexpr(expr)
  if expr isa Symbol
    return 
  end
  callee=[]
  if expr.head == :function
    caller=expr.args[1]
println("caller=$caller")
  elseif expr.head == :call
    append!(callee, findcallerinargs(expr.args[2:end]))
  elseif expr.head == :block
    append!(callee,findcallerinargs(expr.args[2:end]))
  else
    append!(callee, findcallerinargs(expr.args))
  end
  return callee
end

