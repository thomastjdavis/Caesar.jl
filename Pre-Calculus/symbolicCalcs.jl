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
