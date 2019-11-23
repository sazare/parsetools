
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

function parsefiles(fns)
  fs = []

  for afn in fns
    append!(fs, parsefile(afn))
  end
  return fs
end

