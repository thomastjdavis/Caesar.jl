#=TODO:

-write other questions
-change header

=#
using Latexify

include("equations.jl")
# gives a problem with negative angle -2π<ϕ<0 and positive angle θ>360 degrees
#one in degrees, one in radians
function coTerminal()
    ϕ=rand(range(-2π,0,length=25),2) #radian measure
    θ=rand(360:720,2) #degree measure
    
end
#=gives an angle strictly between 0 and 2pi, in increments of pi/12
    returns radian measure angle (divided by π), and the corresponding degree measure

    TODO - make angles more reasonable
=#
angles = setdiff(range(1//4,7//4,step=1//4),[1//1,1//2])
function angleConversion()
    radians = rand(angles)
    (radians,Int(radians*180))
end

function complementSupplement()
    a = rand(1:89)
    b = rand(91:179)
    return ((a,90-a,180-a),(b,180-b))
end

function radianToDegree(quizIO,answerIO)
    conversion = angleConversion()
    println(quizIO,"\\question Convert $(latexify(conversion[1])) \$\\pi\$   to degrees.\\makeemptybox{\\stretch{1}}")
    print(answerIO,"$(conversion[2]),")
end

function degreeToRadian(quizIO,answerIO)
    conversion = angleConversion()
    println(quizIO,"\\question Convert $(conversion[2])° to radians.\\makeemptybox{\\stretch{1}}")
    print(answerIO,"$(conversion[1]) \\pi,")
end

function complementSupplementProblem(quizIO,answerIO)
    csp = complementSupplement()
    print(quizIO,"\\question Calculate the complement and supplement of the following angles (if possible):\n 
                  \\[$(csp[1][1])^{\\circ}\\quad\\quad $(csp[2][1])^{\\circ}\\]\\makeemptybox{\\stretch{1}}")
    print(answerIO,"$(csp[1][2]),$(csp[1][3]),$(csp[2][2]),")
end

function expandLogsProblem(quizIO,answerIO)
    question = expandLogs()
    println(quizIO,"\\question Expand the following expression in terms of \$\\ln u,\\quad \\ln v,\\quad  \\ln w\$. $(question[1]) \\makeemptybox{\\stretch{1}}")
    print(answerIO,"$(question[2]),")
end
function logExtraSolution(quizIO,answerIO)
    question = extraSolutions()
    println(quizIO,"\\question Solve the following equation: \n \\[$(question[1])\\]\\makeemptybox{\\stretch{1}}")
    print(answerIO,"$(question[2]),")
end
#=
what needs to be assessed?
converting between radians to degrees - x1
                   degrees to radians - x1
                   find coTerminal angle in range [0,2pi) given angle measure in radians - x1
                   '' '' in degrees - x1
=#

function questions(answers_file,quiz_file,n)
    answers_io = open(answers_file,"w");
    paper_io = open(quiz_file,"w");

    println(paper_io,raw"""
    \documentclass{exam}
    \usepackage[utf8]{inputenc}
    \usepackage{amsmath}
    \usepackage[shortlabels]{enumitem}
    \usepackage{tikz}
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
    #header for the csv file
    println(answers_io,"ID,1,2,3,4,5a1,5a2,5b(supplement)");
    #makes questions and writes to the latex file, and the .csv file
    for i in 1:n
        
        paperID= i+100
        #writing to csv file
        print(answers_io,"$paperID,")

        #writing to .tex file
        println(paper_io,"\\section*{Quiz 1}")
        println(paper_io,"\\subsection*{Quiz ID: $paperID}")
        println(paper_io,raw"""\makebox[0.4\textwidth]{English Name:\enspace\hrulefill}
        \vspace{0.5cm}\
        \makebox[0.4\textwidth]{Chinese Name:\enspace\hrulefill}
        \vspace{1cm}\\""")
        print(paper_io,"\\begin{questions}\n")
        expandLogsProblem(paper_io,answers_io)
        logExtraSolution(paper_io,answers_io)
        println(paper_io,"\\newpage")
        radianToDegree(paper_io,answers_io)
        degreeToRadian(paper_io,answers_io)
        complementSupplementProblem(paper_io,answers_io)
        #new line
        println(answers_io,"")
        #new quiz
        println(paper_io,"\\end{questions}\\newpage")
    end

    println(paper_io,"\\end{document}")
    close(paper_io);
    close(answers_io);
    println("success!")
end
