include("specialAngles.jl")
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
    }
    \renewcommand{\choicelabel}{(\thechoice)}
    \title{QUIZ 3}
    \begin{document}
    """)
end
#three specialAngles problems
#
#
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

function writeQuiz(quiz_file,n)
    paper_io = open(quiz_file,"w");
    answers_io = open("q4.4.csv","w")
    println(answers_io,"ID,Q4 sin theta (rad),Q5 cos phi (deg), Q6 identity1")
    preamble(paper_io)
    for i in 1:n
        
        paperID= i+100
        #writing to .tex file
        println(paper_io,"\\section*{Quiz 2}")
        println(paper_io,"\\subsection*{Quiz ID: $paperID}")
        println(paper_io,raw"""\makebox[0.4\textwidth]{English Name:\enspace\hrulefill}
        \vspace{0.5cm}\
        \makebox[0.4\textwidth]{Chinese Name:\enspace\hrulefill}
        \vspace{1cm}\\""")
        print(answers_io,"$paperID,")
        print(paper_io,"\\begin{questions}\n")
        #TO DO: put in questions
        specialAngle(paper_io)
        println(paper_io,"\\newpage")
        calculatorQuestion(paper_io,answers_io)
        acuteRandom(paper_io,answers_io)
        println(answers_io,"")
        println(paper_io,"\\end{questions}\\newpage")
    end

    println(paper_io,"\\end{document}")
    close(paper_io);
    close(answers_io);
   # close(answers_io);
    compile = `pdflatex $quiz_file`
    run(compile)
    println("success!")
end