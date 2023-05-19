using Random, Latexify, LinearAlgebra

A = setdiff(-5:5,[0,1])


function distinctVectorPair()
    v1 = rand(A,2)
    while true
        v2 = rand(A,2)
        if v1 != v2
            return (v1,v2)
        end
    end
end

function distinctScalars()
    scalar1 = rand(A)
    while true
        scalar2 = rand(A)
        if scalar1 != scalar2
            return (scalar1,scalar2)
        end
    end
end

function vectorMath()
    vectors = distinctVectorPair()
    v1=vectors[1]
    v2=vectors[2]
    scalars = distinctScalars()
    s = scalars[1]*v1 + scalars[2]*v2
    direction = directionAngle(s)
    info = """
    \\begin{align}
    \\mathbf{v} &= <$(v1[1]),$(v1[2])>\\\\
    \\mathbf{w} &= $(v2[1])\\mathbf{i}+$(v2[2])\\mathbf{j}\\\\
    \\end{align}"""
    prompt = "$info \\question Calculate \$\\mathbf{s}=$(scalars[1])\\vec{v}+$(scalars[2])\\vec{w}\$, and calculate the direction angle of \$\\mathbf{s}\$"
    return (v1,v2,scalars,s,direction,prompt)
end

function randomVector()
    s1 = rand(A)
    s2 = rand(A)
    #h = sqrt(s1^2+s2^2)
    return [s1,s2]
end

function randomUnitVector()
    v = randomVector()
    h = sqrt((v[1])^2+(v[2])^2)
    if isinteger(h)
        u = v.//h
        return string.(u)
    else
        magSquared = (norm(v))^2
        return ("\$\\dfrac{$(v[1])}{\\sqrt{$magSquared}}","\\dfrac{$(v[2])}{\\sqrt{$magSquared}}\$")
    end
end

function directionAngle(v::Vector{T} where T<: Number)
    a = atand(v[2],v[1])
    if a<0
        return 360 + a 
    else
        return a 
    end
end

function dotProduct(v1::Vector{T} where T<: Number,v2::Vector{T} where T<: Number)
    @assert length(v1)==length(v2) "The two vectors have different lengths, and so are incompatible."
    transpose(v1)*v2
end

function angleBetween(v1::Vector{T} where T<: Number,v2::Vector{T} where T<: Number)
    d=dotProduct(v1,v2)
    acosd(d/(norm(v1)*norm(v2)))
end
