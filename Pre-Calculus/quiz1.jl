include("ch1.lib.jl")

function questions(answers_file,quiz_file,n)
    
    answers_io = open(answers_file,"w")
    paper_io = open(quiz_file,"w")

    
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
    \title{QUIZ 8 - RANDOMIZED}
    \begin{document}
    """)
    #header for the csv file
    println(answers_io,"ID,");
    #makes questions and writes to .tex file and .csv file
    for i in 1:n
        paperID = i
        print(answers_io,string(paperID,","))

        
        println(paper_io,"\\section*{Quiz 1}\n\\section*{Quiz ID: $paperID}")
        println(paper_io,raw"""\makebox[0.4\textwidth]{English Name:\enspace\hrulefill}
        \vspace{0.5cm}\
        \makebox[0.4\textwidth]{Chinese Name:\enspace\hrulefill}
        \vspace{1cm}\\""")
        print(paper_io,"\\begin{questions}\n")
        mid = midpointQuestion()
        print(answers_io,string(mid[2],", "))
        print(paper_io,mid[1])

        dis = distanceQuestion()
        print(answers_io,string(dis[2],", "))
        print(paper_io,dis[1])

        lineInt = linear_interceptQuestion()
        print(answers_io,string(lineInt[2],", ",lineInt[3],", "))
        print(paper_io,lineInt[1])
        print(paper_io,"\\newpage")

        circ = circleMC()
        print(answers_io,string(circ[2],","))
        print(paper_io,circ[1])
        println(paper_io,"\\question Fill in the correct English word into the table below. Each item is 4 points out of 100\\%.
        \\vspace{1cm}
        \\begin{table}[h]
        \\centering
        \\resizebox{0.3\\columnwidth}{!}{%
            \\begin{tabular}{|l|l|}
            \\hline
English Word & \\chinese{中文}   \\\\ \\hline
             & \\chinese{Y轴}   \\\\ \\hline
             & \\chinese{散点图}  \\\\ \\hline
             & \\chinese{点的平移} \\\\ \\hline
             & \\chinese{X轴截距} \\\\ \\hline
             & \\chinese{圆的方程} \\\\ \\hline
\\end{tabular}%
}

\\label{tab:my-table}
\\end{table}
        
        ")
        println(paper_io,"\\end{questions}\\newpage")
        println(answers_io)
    end

    print(paper_io,"\\end{document}")
    close(answers_io);
    close(paper_io);
end

function trial()
    
    questions("trialAnswers.csv","trialQuiz1.tex",5)

    run(`pdflatex trialQuiz1.tex`)
    run(`pdflatex trialQuiz1.tex`)

end 