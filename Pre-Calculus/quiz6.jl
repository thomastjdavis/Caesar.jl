using Symbolics
@variables x

A = setdiff(-5:5,[0])

function makeQuestions()
    paperID = rand(UInt16)
    vars = rand(A,5)

    f(x)=vars[1]x+vars[2]
    g(x)=vars[3]x^2+vars[4]x+vars[5]

    q1Answer = f(x)+2*g(x)
    q2Answer = 2*f(x)-g(x)
    q3Answer = g(x)/f(x)
    q4Answer = simplify(expand(f(g(x))))
    q5Answer = simplify(expand(g(f(x))))

    answers = [f(x)+2*g(x),2*f(x)-g(x),g(x)/f(x),q4Answer,q5Answer]
    return (paperID,f(x),g(x),answers)
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
    \title{QUIZ 6 - RANDOMIZED}
    \begin{document}
    """)
    #makes questions and writes to the latex file, and the .csv file
    for i in 1:n
        
        q=makeQuestions()
        #writing to csv file
        println(answers_io,"$(q[1]),")

        #writing to .tex file
        println(paper_io,"\\newpage")
        println(paper_io,"\\section*{Quiz 6}\n\\section*{Quiz ID: $(q[1])}")
        println(paper_io,raw"""\makebox[0.4\textwidth]{English Name:\enspace\hrulefill}
        \vspace{0.5cm}\
        \makebox[0.4\textwidth]{Chinese Name:\enspace\hrulefill}
        \vspace{1cm}\\""")
        println(paper_io,"\n Let ")
        for qi in q[2:3]
            #writing to CSV file
            print(answers_io,qi)
            print(answers_io,",")
        end
        print(paper_io,"\\[f(x)=$(q[2])\\]\n \\[g(x)=$(q[3])\\]")
        print(paper_io,raw"""\begin{questions}
        \question What is $f(x)+2g(x)$?
        \makeemptybox{\stretch{1}}
        \question What is $2f(x)-g(x)$?
        \makeemptybox{\stretch{1}}
        \question What is $g(x)/f(x)$ and its domain?
        \makeemptybox{\stretch{1}}
        \newpage
        \question What is $f(g(x))$?
        \makeemptybox{\stretch{1}}
        \question What is $g(f(x))$?
        \makeemptybox{\stretch{1}}
    \end{questions}""")
        for qAnswer in q[4]
            #writing to CSV file
            print(answers_io,qAnswer)
            print(answers_io,",")
            # no writing to tex file - more secure

        end

        #new line
        println(answers_io,"")
        #new quiz
        println(paper_io,"\newpage")
    end

    println(paper_io,"\\end{document}")
    close(paper_io);
    close(answers_io);
    println("success!")
end
