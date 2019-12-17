
function comprehensionf(xx)
        xs=[]
        for x in 1:xx
          push!(xs, x+1)
        end
        xs
      end

function comprehension(xx)
        [x+1 for x in 1:xx]
end

@time d10=comprehension(100000);
@time d10=comprehension(100000);

@time d10=comprehensionf(100000);
@time d10=comprehensionf(100000);
