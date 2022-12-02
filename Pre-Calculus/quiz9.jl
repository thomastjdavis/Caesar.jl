include("lib.jl")

function printCubic(quizFileIO,answersFileIO)
    prob = cubicRoots()
    println(quizFileIO,"\\question Given that \$x=$(prob[1])\$ is a root of \$f(x)\$, find the other two roots.\\[f(x)=")
    printpoly(quizFileIO,prob[4],descending_powers=true,mulsymbol="")
    println(quizFileIO,"\\]\\makeemptybox{\\stretch{1}}")

    print(answersFileIO,"$(prob[2]),$(prob[3]),")
end

function printQuartic(quizFileIO,answersIO)
    quarticProblem = quarticRoots()
    z1=latexify(quarticProblem[2],env=:raw)

    println(quizFileIO,"\\question Given that \$$(z1)\$ is a root of the function \$p(x)=")
    printpoly(quizFileIO,quarticProblem[3],descending_powers=true,mulsymbol="");
    println(quizFileIO,"\$, find all roots of \$p(x)\$. \\makeemptybox{\\stretch{1}}") 

    print(answersIO,"$(quarticProblem[1][1]),$(quarticProblem[1][2]),$(conj(quarticProblem[2]))");
end

function header(answersIO)
    println(answersIO,"Paper ID,Q1 root 1,Q1 root 2,Q2 RealRoot1,Q2 RealRoot2,Q2 complex")
end

function questions(quiz_file,answers_file,n)
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
    \title{QUIZ 9 - RANDOMIZED}
    \begin{document}
    """)
    #header for the csv file
   header(answers_io)
    #makes questions and writes to the latex file, and the .csv file
    for i in 1:n
        
        paperID= i+100
        #writing to csv file
        print(answers_io,"$paperID,")

        #writing to .tex file
        println(paper_io,"\\newpage")
        println(paper_io,"\\section*{Quiz 9}\n\\section*{Quiz ID: $paperID}")
        println(paper_io,raw"""\makebox[0.4\textwidth]{English Name:\enspace\hrulefill}
        \vspace{0.5cm}\
        \makebox[0.4\textwidth]{Chinese Name:\enspace\hrulefill}
        \vspace{1cm}\\""")
        print(paper_io,"\\begin{questions}\n")
        printCubic(paper_io,answers_io)
        println(paper_io,"\\newpage")
        printQuartic(paper_io,answers_io)
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