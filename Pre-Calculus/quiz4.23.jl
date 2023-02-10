using Latexify

#can adapt to a unit circle triangle by picking x=s1/h, y =s2/h.
function randomRightTriangle()
    s1 = rand(1:6)
    s2 = rand(setdiff(1:6,[s1]))
    h = sqrt(s1^2+s2^2)
    #swaps s1,s2 so that the bigger number is first
    if s1<s2
        tmp=s2
        s2=s1
        s1=tmp
    end
    if isinteger(h)
        h=Int(h)
        return (s1,s2,"$h")
    else
        return (s1,s2,"\\sqrt{$(s1^2+s2^2)}")
    end
end

function tikzRightTriangle()
    T = randomRightTriangle()
    # hiddenSide = rand(1:3)
    tStrings = string.(T)
    #randomly selects a side to hide
    #replace!(tStrings,x-> x==hiddenSide ? "" : x)
    """\\draw (0,0) -- ($(T[1]),0) node[pos=0.5,anchor=north]{$(tStrings[1])} node[pos=0.25,anchor=south]{\$\\theta\$} -- ($(T[1]),$(T[2])) node[pos=0.5,anchor=west]{$(tStrings[2])} --(0,0) node[pos=0.4,anchor=south east]{\$$(tStrings[3])\$};"""
end

function trial()
    fileIO = open("trial.tex","w")
    println(fileIO,raw"""
    \documentclass{exam}
    \usepackage[utf8]{inputenc}
    \usepackage{amsmath}
    \usepackage[shortlabels]{enumitem}
    \usepackage{tikz}
    \usepackage{subcaption}
    \usepackage{multicol}
    \graphicspath{{./graphs}}
    \newcommand{\chinese}[1]{\begin{CJK}{UTF8}{gbsn}#1\end{CJK}}
    \newcommand{\plane}[1][5]{
        \draw[very thin,color=gray] (-{#1},-{#1}) grid ({#1},{#1});
        \draw[thick,<->] (-{#1},0) -- ({#1},0) node[anchor=north west] {$x$};
        \draw[thick,<->] (0,-{#1}) -- (0,{#1}) node[anchor=south west] {$y$};
    }
    \renewcommand{\choicelabel}{(\thechoice)}
    \title{QUIZ 8 - RANDOMIZED}
    \begin{document}
    """)
    println(fileIO,"""
    \\begin{figure}
        \\centering
        \\begin{subfigure}{.4\\textwidth}
        \\begin{tikzpicture}
            $(tikzRightTriangle())
            \\end{tikzpicture}
        \\end{subfigure}
        \\begin{subfigure}{.4\\textwidth}
             
            \\centering
            \\begin{tabular}{ll}
                \$\\sin(\\theta)\$= & \$\\csc(\\theta)\$= \\\\ 
                \$\\cos(\\theta)\$= & \$\\sec(\\theta)\$= \\\\
            \$\\tan(\\theta)\$= & \$\\cot(\\theta)\$= 
        \\end{tabular}
        
        \\end{subfigure}
        \\caption{The problem, bro}
    \\end{figure}
    \\begin{figure}
        \\centering
        \\begin{subfigure}{.4\\textwidth}
        \\begin{tikzpicture}
            $(tikzRightTriangle())
            \\end{tikzpicture}
        \\end{subfigure}
        \\begin{subfigure}{.4\\textwidth}
             
            \\centering
            \\begin{tabular}{ll}
                \$\\sin(\\theta)\$= & \$\\csc(\\theta)\$= \\\\ 
                \$\\cos(\\theta)\$= & \$\\sec(\\theta)\$= \\\\
            \$\\tan(\\theta)\$= & \$\\cot(\\theta)\$= 
        \\end{tabular}
        
        \\end{subfigure}
        \\caption{The problem, bro}
    \\end{figure}
    
    \\end{document}
        """)
        
    close(fileIO)

    compile = `pdflatex trial.tex`
    run(compile)

end
trial()
