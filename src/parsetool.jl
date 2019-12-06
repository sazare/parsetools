
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

function showtypes(es)
  map(x->(x isa Expr && x.head),es)
end

#####
# finding callee
function findcallee(args::Array)
  callee = []
  for arg in args
    if arg isa Expr
      append!(callee,findcallerinexpr(arg))
    end
  end
  return callee
end


#####
# finding caller

function findcaller(ea::Array)
  callers=[]
  map(e->append!(callers,findcaller(e)),ea)
  return callers
end

function findcaller(sym::Symbol)
  return []
end

function findcaller(expr::Expr)
  if expr.head == :function
    return [expr.args[1]]
  elseif expr.head == :call
    return [expr.args[1]]
  elseif expr.head == :(=)
    return [expr.args[1]]
  else
    return []
  end
end

