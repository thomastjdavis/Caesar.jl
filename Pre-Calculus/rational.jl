include("lib.jl")

#=
    generateRational is complex requiring multiple dispatch to effectively randomize
=#
function generateRational(degrees=[1,2];noCommmonFactors=false)
    f = generatePolynomial(degrees[1])
    g = generatePolynomial(degrees[2])
    return (f,g)
end

#need functions for rational functions with greater top degree, greater bottom degree and equal top and bottom degree
function sameDegreeRational(degree=2)
    generateRational([degree,degree])
end

function greaterTopDegree(degree=2)
    if degree == 1
        return (generatePolynomial(1),rand(A))
    end
    generateRational([degree,rand(0:degree-1)])
end

function lesserTopDegree(degree=2)
    reverse(greaterTopDegree(degree))
end
