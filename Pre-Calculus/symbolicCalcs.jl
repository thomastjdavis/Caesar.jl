#=
most of the setup time comes from loading SymEngine=#
using SymEngine

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
    
    (expr,sub,newexpr,[bs1,bs2,bs3])
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
            prompt = prompt*"\\choice"*string(l[3])
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
    prompt="""Write an equation of a line passing through the point $(Tuple(point)) with slope \$m\$=$(latexify(slope))"""
    expr = expand(slope*(x-point[1])+point[2])
    expr=replace(string(expr),"*"=>"","("=>"",")"=>"","x"=>" x")
    (prompt,string("y=",expr))
end

#TO DO: make function "implicitMult","implicitMult!"
