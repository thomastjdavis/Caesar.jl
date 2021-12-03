export poly, hasRationalRoots

struct poly
  n::UInt64
  coeffs::Vector{Int64}
  #coeffs.length=n+1
end

#evaluates the polynomial at x
#currently bugged - try horner's method instead
function eval(p::poly,x)
  sum = p.coeffs[1]
  for i in 2:(p.n)+1
    sum += p.coeffs[i]*(x)^(i+1)
  end
  sum
end

#=currently misses roots. I suspect eval isn't working properly
test cases:
	2x^3+x-1 -> no rational roots
	x^3-7x+6 -> rational roots at x=1,2,-3
	
=#
function hasRationalRoots(p::poly)
  roots = []
  f0 = factor(p.coeffs[1])
  fn = factor(p.coeffs[(p.n)+1])
  for i in 1:length(f0)
    for j in 1:length(fn)
      testRoot1 = f0[i]/fn[j]
      testRoot2 = -f0[i]/fn[j]

      if eval(p,testRoot1)==0
        push!(roots,testRoot1)
      end
      if eval(p,testRoot2)==0
		push!(roots,testRoot2)
      end
    end
  end
  if length(roots)==0
    return "No rational roots"
  else
    return roots
  end
end

function factor(n::Int)
  #finds the factors of n
  f=[1]
  for i in 2:Int(floor(sqrt(abs(n))))+1
    try Int(n/i)
        push!(f,i)
    catch
        continue
    end
  end
 push!(f,n)
end


