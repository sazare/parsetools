
# this is good
"""
 showtypes shows toplevel type of Array of something
"""
function showtypes(es)
  es
end

# This is bad
"""
 this is bad
"""
function unexpectedone(es)
  es
end

### see Meta.parse(thisfile) 

function f(x)
  function g(x)
    x*x
  end
  x+g(x)
end

