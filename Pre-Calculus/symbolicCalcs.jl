#=
most of the setup time comes from loading SymEngine=#
using SymEngine, Random, RationalGenerators, Polynomials

x=symbols(:x)
h=symbols(:h)
function linearEval()
    a=rand(setdiff(-5:5,[0]))
    b=rand(setdiff(-5:5,[0,a]))
    c=rand(setdiff(-5:5,[0,a,b]))
    #lets f(x)=ax+b with the specific a,b randomly chosen
    expr=a*x+b
    sub = x=>x+c
    badsub1=x=>x-c
    badsub2=x=>c-x
    badsub3=x=>-x-c
    
    #calculates f(x+c)
    newexpr = expand(subs(expr,sub))
    #calculates f(x-c)
    bs1=subExpand(expr,badsub1)
    #calculates f(c-x)
    bs2=subExpand(expr,badsub2)
    #calculates f(-x-c)

    bs3=subExpand(expr,badsub3)
    
    (expr,sub,newexpr,[bs1,bs2,bs3],c)
end


function subExpand(expr,substitution)
    expand(subs(expr,substitution))
end

function linearEvalProblem()
    l=linearEval()
    prompt = """\\question Let \$ f(x)=$(l[1])\$. What is \$f($(l[2][2]))\$?\\begin{choices}"""
    badExpressions = l[4]
    incorrect1="\$ $(badExpressions[1])\$"
    incorrect2="\$ $(badExpressions[2])\$"    
    incorrect3="\$ $(badExpressions[3])\$"
    correctChoice = rand(1:4)
    permutedAnswers = shuffle([incorrect1,incorrect2,incorrect3])
    j=1
    for i in 1:4
        if i==correctChoice
            prompt = prompt*"\\choice\$"*string(l[3])*"\$"
        else
            prompt = prompt *"\\choice" *permutedAnswers[j]
            j=j+1
        end

    end
    prompt = prompt * "\\end{choices}"

    #need to remove *
    prompt=replace(prompt,"*"=>"")
    choices = ["A","B","C","D"]
    (prompt,choices[correctChoice])
end

function slopePoint()
    slopes = collect(t for t in SmallRatGen(5) if t<1) 
    slope=rand(slopes)
    point=rand(setdiff(-5:5,[0,1]),2)
    prompt="""\\question Write an equation of a line passing through the point $(Tuple(point)) with slope \$m\$=$(latexify(slope))\\makeemptybox{\\stretch{1}}"""
    expr = expand(slope*(x-point[1])+point[2])
    expr=replace(string(expr),"*"=>"","("=>"",")"=>"","x"=>" x")
    (prompt,string("y=",expr))
end

#TO DO: make function "implicitMult","implicitMult!"

"""
    divideByZero()

Uses Polynomials to generate a rational polynomial of degree 0,2  where the bottom excludes 
the second and third output. The second and third output will be different. 
Sample output:

divideByZero()\n
(Polynomial(20-9*x+x^2),4,5)
"""
function divideByZero()

    a=rand(setdiff(-5:5,[0,1]))
    b=rand(setdiff(-5:5,[0,1,a]))
    expr=fromroots([a,b];var=:x)
    (expr,a,b)
end

"""
    divideByZeroDomainProblem(answersIO,quizIO)

Directly uses answersIO, and quizIO to insert the question
"""
function divideByZeroDomainProblem(answersIO,quizIO)
    d=divideByZero()
    print(answersIO,"x\\ne $(d[2]), x\\ne$(d[3]),")
    print(quizIO,"""\\question What is the domain of the following function:
    \\[h(x)=\\dfrac{1}{""")
    printpoly(quizIO,d[1],descending_powers=true,mulsymbol="")
    print(quizIO,"""}\\]\\makeemptybox{\\stretch{1}}""")
end
"""
    quadraticDifferenceQuotient()

    Uses Polynomials.jl to compute with (f(x+h)-f(x))/h, giving the result of the difference quotient:
    2ax+h+b.
"""
function quadraticDifferenceQuotient()
    a=rand(setdiff(-5:5,[0]))
    b=rand(setdiff(-5:5,[0,a]))
    c=rand(setdiff(-5:5,[0,a,b]))
    starting = Polynomial([c,b,a])
    goalExpression=Polynomial([b+h,2a])
    (starting,goalExpression)
end
"""
    quadraticDifferenceQuotientProblem(answersIO,quizIO)

    Uses quadraticDifferenceQuotient() as data for a difference quotient problem involving a quadratic function.
    LaTeX code for the question is inserted into quizIO, and the answer into answersIO.

    See ?quadraticDifferenceQuotient() for more details.

"""
function quadraticDifferenceQuotientProblem(answersIO,quizIO)
    qdq=quadraticDifferenceQuotient()
    print(quizIO,"\\question Recall the difference quotient of a function, 
    \$f(x)\$:\\[\\dfrac{f(x+h)-f(x)}{h}\\]
    Let \$h(x)=")
    printpoly(quizIO,qdq[1],descending_powers=true,mulsymbol="")
    print(quizIO,"\$. What is the difference quotient of \$h(x)\$?\\makeemptybox{\\stretch{1}} ")
    printpoly(answersIO,qdq[2],descending_powers=true,mulsymbol="")
    print(answersIO,",")
end
function averageRateOfChange()
    x0=rand(-5:-1)
    x1=rand(1:5)
    a=rand(setdiff(2:5,[0]))
    b=rand(setdiff(-5:5,[0,a]))

    f = Polynomial([0,0,b,a])
    Δy= f(x1)-f(x0)
    Δx= x1-x0
    if isinteger(Δy//Δx)
        return (x0,x1,Int(Δy//Δx),f)
    end
    (x0,x1,Δy//Δx,f)
end

function averageRateOfChangeProblem(answersIO,quizIO)
    data=averageRateOfChange()
    print(quizIO,"\\question Find the average rate of change of \$g(x)=")
    printpoly(quizIO,data[4],descending_powers=true,mulsymbol="")
    print(quizIO,"\$ on \$x_1 = $(data[1])\$ to \$x_2=$(data[2])\$.\\makeemptybox{\\stretch{1}}")
    print(answersIO,string(data[3],","))
end


"""
    mobiusInversion()

Creates a  mobius transformation f(x)=(ax+b)/(cx+d) such that ad-bc≠0.
    Such a transformation is invertible and has a closed form solution for the inverse, ie:
        f^{-1}(x)=(-dx+b)/(cx-a)
"""
function mobiusInversion()
    #TO DO
end