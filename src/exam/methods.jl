## study method dispatch
struct A
 x::String
end

struct B
 y::Number
end

struct C
 z::Symbol
end


f(x::A) = "with A"
f(x::Any) = "with others"
f(x::B) = "with B"

using Test

@test f(A("i am A")) == "with A"
@test f(B(123)) == "with B"
@test f(C(:others)) == "with others" 
@test f(124) == "with others"


