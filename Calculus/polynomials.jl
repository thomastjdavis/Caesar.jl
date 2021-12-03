export poly, hasRationalRoots
struct poly
  n::UInt64
  coeffs::Vector{Int64}
  #coeffs.length=n+1
end

#evaluates the polynomial at x
function eval(p::poly,x)
  sum = poly.coeffs[1]
  for i in 2:(p.n)+1
    sum += p.coeffs[i]*(x)^(i+1)
  end
  sum
end

function hasRationalRoots(p::poly)
  roots = []
  f0 = factor(p.coeffs[1])
  fn = factor(p.coeffs[(p.n)+1])
  for i in 1:length(f0)
    for j in 1:length(fn)
      testRoot1 = f0[i]/fn[j]
      testRoot2 = -f0[i]/fn[j]
      if eval(p,testR
        oot1)==0
        push!(roots,testRoot1)
      end
      if eval(p,testRoot2)==0
        push!(roots,testRoot2)
      end
    end
  end
  if length(roots)>0
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



