
# this is good
"""
 showtypes shows toplevel type of Array of something
"""
function showtypes(es)
  f1(es)
end

# This is bad
"""
 this is bad
"""
function unexpectedone(es)
  f2(es)
end

### see Meta.parse(thisfile) 

function f(x)
  function g(x)
    x*x
  end
  x+g(x)
end

