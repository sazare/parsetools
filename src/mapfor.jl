
function elemf(x)
  length(x)
end

function loopm(ls::Array)
  map((x)->elemf(x), ls)
end

function loopf(ls::Array)
  a = []
  for x in ls
    push!(a, elemf(x))
  end
  a
end

ddk=map((x)->[x], collect(1:1000))
@show :size1000
GC.gc()
@show :loopm; @time loopm(ddk)
@show :loopf; @time loopf(ddk)

ddm=map((x)->[x], collect(1:1000000))
@show :size1000000
GC.gc()
@show :loopm; @time loopm(ddm)
@show :loopf; @time loopf(ddm)

ddm=map((x)->[x], collect(1:10000000))
@show :size10000000
GC.gc()
@show :loopm; @time loopm(ddm)
@show :loopf; @time loopf(ddm)

#==
## too long time
ddm=map((x)->[x], collect(1:100000000))
@show :size100000000
GC.gc()
@show :loopm; @time loopm(ddm)
@show :loopf; @time loopf(ddm)

ddg=map((x)->[x], collect(1:1000000000))
@show :size1000000000
GC.gc()
@show :loopm; @time loopm(ddg)
@show :loopf; @time loopf(ddg)
==#
;


