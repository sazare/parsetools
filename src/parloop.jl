xm=collect(1:1000000)
ym=collect(1:1000000)

@show :map
GC.gc()
@time map((x,y)->[x,y],xm,ym)


@show :for
xym=[]
GC.gc()
@time for i in 1:length(xm) ; append!(xym,[xm[i],ym[i]]) end

