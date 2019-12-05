#sample.jl
f1(x)=x+x

begin
z=f1(3)
z+=3
end

@show :hi

struct Mine
 a::String
 b::Int
end

function f2(x::Int)::Int
 if x==0; return 1 end
 f1(x)
end

function f3(x)
 return f2(x)
end

function f4(x)
 f3(x)
end

f5(x) = f4(x)

macro sayhello(name)
 return :( println("Hello, ", $name, "!") )
end

@sayhello "Charlie"

