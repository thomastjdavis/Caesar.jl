using Polynomials, RationalGenerators

#to guarantee that you'll end up with a solvable quadratic in sine/cosine
smallValues = [t for t in SmallRationalGenerator(10) if t<1]

function quadraticTrigEquation(duplicateRoot::Bool=false)
    t1=rand(smallValues)
    factor1=factorFromRational(t1)
    if duplicateRoot
       t2=t1 
    else
        t2=rand(setdiff(smallValues,[t1]))
    end
    factor2=factorFromRational(t2)
    #our polynomial with roots t1,t2
    polynomial=factor1*factor2
    s=string(polynomial)
    #this step needs fixing - keeps giving an error
    replace!(String,s,"x^2"=>"y")
    replace!(s,"x"=>"\\sin x")
    replace!(s,"y"=>"\\sin^{2}x")
    (factor1,factor2,s)
end

#if q=a//b, then a polynomial with root q is
#a-bx, which is constructed from here.
function factorFromRational(q)
    Polynomial([q.num,-q.den])
end
