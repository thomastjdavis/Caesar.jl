#=
most of the setup time comes from loading SymEngine=#
using SymEngine, Random, RationalGenerators, Polynomials

x=symbols(:x)

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

