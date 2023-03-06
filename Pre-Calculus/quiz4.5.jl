using Latexify
include("randomTriangles.jl")
function preamble(paperIO)
    println(paperIO,raw"""
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
        \node[anchor=west] at (0,1) {1};
        \node[anchor=north] at (-4,0) {$-2\mathbf{\pi}$};
        \node[anchor=north] at (-2,0) {$-\mathbf{\pi}$};
        \node[anchor=north] at (2,0) {$\mathbf{\pi}$};
        \node[anchor=north] at (4,0) {$2\mathbf{\pi}$};
    }
    \renewcommand{\choicelabel}{(\thechoice)}
    \title{QUIZ 4}
    \begin{document}
    """)
end

function calcs()
    #radian
    theta = rand(range(0.2,6.0,step=0.35))
    #degree
    phi = rand(range(5,187,step=2.35))

    [theta,sin(theta),phi,cosd(phi)]
end

function calculatorQuestion(paperIO,answersIO)
    calc = calcs()
    println(paperIO,    
    "\\question Using your calculator, find \$\\sin $(calc[1])\$
     \\question Using your calculator find \$\\cos $(calc[3])^{\\circ}\$")
    print(answersIO,"$(calc[2]),$(calc[4]),")
end

function addParity(a)
    
    sign(a)==1 ? "+$a" : "$a"
end

function sineGraph()
    #might change implementation
    amplitude=rand(2:4)
    shift = rand(1:5-amplitude)
    questionString = "\\question Sketch the graph of \$$amplitude\\sin(x)$(addParity(shift))\$." 
    return (amplitude,shift,questionString)
end

function cosGraph()
    #might change implementation
    amplitude=-1*rand(2:4)
    shift = -1*rand(1:5+amplitude)
    questionString = "\\question Sketch the graph of \$$amplitude\\cos(x)$(addParity(shift)).\$" 
    return (amplitude,shift,questionString)

end

function graphQuestion(paperIO,answersIO,question)
    
    println(paperIO,question[3])
    println(paperIO,"""\\begin{figure}[h]
    \\centering
        \\begin{tikzpicture}[scale=0.7]
        \\plane
        \\end{tikzpicture}
    \\end{figure}""")
    print(answersIO,"$(question[1]),")
    print(answersIO,"$(question[2]),")
end

function makeQuiz(quizFile,answerFile,n)
    io=open(quizFile,"w")
    answersIO = open(answerFile,"w")
    println(answersIO,"quizID,amplitude1,vShift1,amplitude2,vShift2,sin(theta),cosd(phi),missingSide")
    paperID = 300
    preamble(io)
    for i in 1:n
        paperID=paperID+1
        print(answersIO,"$paperID,")
        println(io,"\\section*{Quiz 45}")
        println(io,"\\subsection*{Quiz ID: $paperID}")
        println(io,raw"""\makebox[0.4\textwidth]{English Name:\enspace\hrulefill}
        \vspace{0.5cm}\
        \makebox[0.4\textwidth]{Chinese Name:\enspace\hrulefill}
        \vspace{1cm}\\""")
        println(io,"\\begin{questions}")
        s=sineGraph()
        c=cosGraph()
        graphQuestion(io,answersIO,s)
        graphQuestion(io,answersIO,c)
        println(io,"\\newpage\\subsection*{Quiz ID:$paperID}")
        calculatorQuestion(io,answersIO)
        acuteRandom(io,answersIO)
        println(io,"""\\begin{table}[b]
        \\centering
        \\begin{tabular}{|l|l|l|l|l|l|l|}
        \\hline
        \\textbf{Question} & 1(/20) & 2(/20) & 3(/20) & 4(/20) & 5(/20) & \\textbf{Total (/100)} \\\\ \\hline
        \\textbf{Score}    &        &        &        &        &        &                      \\\\ \\hline
        \\end{tabular}
        \\end{table}""")
        println(io,"\\end{questions}\\newpage")
        print(answersIO,"\n")
    end
    println(io,"\\end{document}")
    close(io)
    close(answersIO)
    run(`pdflatex $(quizFile)`)
    run(`more $(answerFile)`)
end
makeQuiz("quiz4.5(main).tex","quiz4.5.csv",55)