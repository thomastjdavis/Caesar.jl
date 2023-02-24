using Polynomials
A = setdiff(-5:5,[0])

function distinctRandom(Sampler,n)

    if n>length(Sampler)
        throw(BoundsError(Sampler,n))
    end 
    #base case of recursion
    if n==1 
        return rand(Sampler)
    end
    v=[]
    for i in 1:n
        new_sample=rand(setdiff(Sampler,v))
        push!(v,new_sample)
    end
    v
end
    
#need to use degree >= 1
function generatePolynomial(degree)
    #degree= degree+1
    if degree ==0 || degree ==1
        return Polynomial(rand(A,degree+1));
    end
    notLeading = rand(-5:5,degree-1)
    coefficients = append!(notLeading,rand(A))
    return Polynomial(coefficients,:x)
end

function lesserDegreePolynomial(degree)
    if degree<=1
        return (Polynomial(rand(A)),degree)
    end
    divisor_degree = rand(1:degree-1)
    (generatePolynomial(divisor_degree),divisor_degree)
end

#=
Here maxDegree is the maximum degree of the quotient.
=#
function divisionProblem(maxDegree)
    d = generatePolynomial(maxDegree)
    q = lesserDegreePolynomial(maxDegree)
    r = lesserDegreePolynomial(d[2]-1)
    f=q[1]*d+r[1]
    (f,q,d,r)
end

function complexEvaluation()
    nums = rand(A,4)
    z1= nums[1]+nums[2]im
    z2=nums[3]+nums[4]im
    if (z1==z2)
        return complexEvaluation()
    end
    (z1+z2,z1*z2,z1//z2,z1,z2)
end

#generates a real polynomial with 1 conjugate pair of complex roots, and 1 real root
function cubicRoots()
    a=rand(A)
    nums = rand(A,2)
    z1= nums[1]+nums[2]im
    z2=conj(z1)
    p=fromroots([a,z1,z2])
    (a,z1,z2,p)
end

#generates a real polynomial with 1 conjugate pair of complex roots, and 2 real roots
#real roots are not guaranteed to be unique
function quarticRoots()
    realRoots = rand(A,2)
    nums= rand(A,2);
    z1 = nums[1]+nums[2]im;
    p = fromroots(union(realRoots,[z1,conj(z1)]));
    (realRoots,z1,p)
end
