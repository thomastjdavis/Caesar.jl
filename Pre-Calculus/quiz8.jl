using Polynomials, Latexify

include("./lib.jl")

function printDivisionProblem(answersFileIO,quizFileIO)
    problem = divisionProblem(2)
    q=problem[1]

    d=problem[2][1]
    r=problem[3][1]

    f = q*d+r
    println(quizFileIO,"\\question Calculate the following division:\\[\\dfrac{")
    printpoly(quizFileIO,f,descending_powers=true,mulsymbol="")
    println(quizFileIO,"}{");
    
    printpoly(quizFileIO,d,descending_powers=true,mulsymbol="")
    println(quizFileIO,"}=\\] \\makeemptybox{\\stretch{2}}")

    printpoly(answersFileIO,q,descending_powers=true,mulsymbol="")
    print(answersFileIO,",")
    printpoly(answersFileIO,r,descending_powers=true,mulsymbol="")
    print(answersFileIO,",")
end

function printSyntheticDivision(answersFileIO,quizFileIO)
    f = generatePolynomial(3)
    a = rand([-1,1])
    result = f(a)

    println(quizFileIO,"\\question Calculate \$f($a)\$ using Synthetic Division and the Remainder Theorem, where\\[f(x) = ")
    printpoly(quizFileIO,f,descending_powers=true,mulsymbol="")
    println(quizFileIO,"\\]\\makeemptybox{\\stretch{1}}")
    
    print(answersFileIO,"$(f(a)),")
end

function printComplexEvaluation(answersFileIO,quizFileIO)
    c=complexEvaluation()
    z1=latexify(c[4],env=:raw)
    z2=latexify(c[5],env=:raw)
    println(quizFileIO,"\\question Calculate \$z_1+z_2\$, \$z_1\\cdot z_2\$ and \$\\dfrac{z_1}{z_2}\$, where:\\[z_1=$(z1)\\]\\[z_2=$(z2)\\]\\makeemptybox{\\stretch{1}}")
    print(answersFileIO,"$(c[1]),$(c[2]),$(c[3]),")
end

function printLastExample(answersFileIO,quizFileIO)
    prob = lastExample()
    println(quizFileIO,"\\question Given that \$x=$(prob[1])\$ is a root of \$f(x)\$, find the other two roots.\\[f(x)=")
    printpoly(quizFileIO,prob[4],descending_powers=true,mulsymbol="")
    println(quizFileIO,"\\]\\makeemptybox{\\stretch{1}}")

    print(answersFileIO,"$(prob[2]),$(prob[3])")
end

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
    println(answers_io,"ID,Q(x),R(x),r,z1+z2,z1*z2,z1//z2,z/z-bar");
    #makes questions and writes to the latex file, and the .csv file
    for i in 1:n
        
        paperID= i+100
        #writing to csv file
        print(answers_io,"$paperID,")

        #writing to .tex file
        println(paper_io,"\\newpage")
        println(paper_io,"\\section*{Quiz 8}\n\\section*{Quiz ID: $paperID}")
        println(paper_io,raw"""\makebox[0.4\textwidth]{English Name:\enspace\hrulefill}
        \vspace{0.5cm}\
        \makebox[0.4\textwidth]{Chinese Name:\enspace\hrulefill}
        \vspace{1cm}\\""")
        print(paper_io,"\\begin{questions}\n")
        printDivisionProblem(answers_io,paper_io)
        printSyntheticDivision(answers_io,paper_io)
        print(paper_io,"\\newpage")
        printComplexEvaluation(answers_io,paper_io)
        printLastExample(answers_io,paper_io)
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
