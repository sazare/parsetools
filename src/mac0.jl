
using Test

macro arrayfunc(name)
  :(function $name(ae::Array)
    somes = []
    for e in ae
      append!(somes, $name(e))
    end
    return somes
  end)
end

@arrayfunc(nemo)

function nemo(x::String)
  println("me=$x")
  return [x]
end

@test nemo(["abc", "bbbb"]) == ["abc", "bbbb"]

