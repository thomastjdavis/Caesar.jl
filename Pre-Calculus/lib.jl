A = setdiff(-5:5,[0])
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
    return (generatePolynomial(divisor_degree),divisor_degree)
    
end

#=
Here maxDegree is the maximum degree of the quotient.
=#
function divisionProblem(maxDegree)
    d = generatePolynomial(maxDegree)
    q = lesserDegreePolynomial(maxDegree)
    r = lesserDegreePolynomial(d[2]-1)
    f=q[1]*d+r[1]
    return (f,q,d,r)
end

function complexEvaluation()
    nums = rand(A,4)
    z1= nums[1]+nums[2]im
    z2=nums[3]+nums[4]im
    if (z1==z2)
        return complexEvaluation()
    end
    return (z1+z2,z1*z2,z1//z2,z1,z2)
end

function cubicRoots()
    a=rand(A)
    nums = rand(A,2)
    z1= nums[1]+nums[2]im
    z2=nums[1]-nums[2]im
    p=fromroots([a,z1,z2])
    return (a,z1,z2,p)
    
end