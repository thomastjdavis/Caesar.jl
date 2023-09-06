using Plots, Polynomials

#sucks
function increasingDecreasingPolynomial()
    #chooses points to have turning points
    criticalNumbers =  [rand(-5:5)]
    push!(criticalNumbers, rand(setdiff(-5:5,criticalNumbers)))
    functionDerivative = fromroots(criticalNumbers)
    myPoly = integrate(functionDerivative,0)
    xLimits = [minimum(criticalNumbers)-1,maximum(criticalNumbers)+1]
    yLimits = [myPoly(val) for val in xLimits]
    p= plot(;legend=:false,xlims=xLimits,ylims=[minimum(yLimits),maximum(yLimits)])
    plot!(p,myPoly)
    for c in criticalNumbers
        scatter!(p,(c,myPoly(c)))
    end
    println(myPoly)
    p
end

function piecewiseLinear()
    changePoints= [-2,1]
    slopes = rand(setdiff(-5:5,[0]),3)
    b = rand(setdiff(-5:5,[0]),3)
    function fuck(x)
        if x∈changePoints
            return NaN
        end
        if x<-2
            return slopes[1]x+b[1]
        elseif -2<x<1 
            return slopes[2]x+b[2]
        else
            return slopes[3]x+b[3]
        end
    end
    plot(fuck,xlims=[-5,5],xticks=-5:5)
    scatter!((-2,fuck(-2.1)),color=:red)
end

#non-linear 
function graph()
    #basepoint
    y0 = rand(-3:3)
    points = [(-5,y0)]
    
    #second point
    x1 = rand(-3:-1)
    y1=rand(setdiff(-5:5,[y0]))
    
    intervals = [((-5,x1),compare(y0,y1))]
    push!(points,(x1,y1))

    #third point
    x2=rand(1:3)
    y2=rand(setdiff(-5:5,[y1]))
    push!(points,(x2,y2))
    push!(intervals,((x1,x2),compare(y1,y2)))

    #final point
    y3=rand(setdiff(-5:5,[y2]))
    push!(points,(5,y3))
    push!(intervals,((x2,5),compare(y2,y3)))
    (points,intervals)
end

function fancyGraph(io)
    paper_io=open(io,"w")
    println(paper_io,raw"""
    \documentclass{exam}
    \usepackage[utf8]{inputenc}
    \usepackage{amsmath}
    \usepackage[shortlabels]{enumitem}
    \usepackage{tikz}
    \usepackage{CJKutf8}
    \usepackage{multicol}
    \usepackage{graphicx}
    \graphicspath{{./graphs}}
    \newcommand{\chinese}[1]{\begin{CJK}{UTF8}{gbsn}#1\end{CJK}}
    \newcommand{\plane}[1][5]{
        \draw[very thin,color=gray] (-{#1},-{#1}) grid ({#1},{#1});
        \draw[thick,<->] (-{#1},0) -- ({#1},0) node[anchor=north west] {$x$};
        \draw[thick,<->] (0,-{#1}) -- (0,{#1}) node[anchor=south west] {$y$};
    }
    \renewcommand{\choicelabel}{(\thechoice)}
    \renewcommand{\arraystretch}{1.5}
    \title{QUIZ 2 - RANDOMIZED}
    \begin{document}
    \begin{figure}[h]
    \begin{tikzpicture}
    \plane 
    """)
    myGraph = graph()
    println(paper_io, string("\\draw[thick] ",myGraph[1][1]," sin ", myGraph[1][2], " cos ", myGraph[1][3], "sin ", myGraph[1][4],";"))
    
    println(paper_io,"\\end{tikzpicture}\\end{figure}")
    for index in 1:3
        println(paper_io,string("\n The function is ",myGraph[2][index][2], " on ", myGraph[2][index][1],"."))
    end
    println(paper_io,"\\end{document}")
    close(paper_io)
end

function makeGraphy()
    fancyGraph("trial.tex")
    run(`pdflatex trial.tex`)
end
function compare(value1,value2)
    value1<value2 ? "increasing" : "decreasing"
end


