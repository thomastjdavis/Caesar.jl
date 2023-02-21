using Latexify

#""a point on the circle has coords (x,y) calculate the six trig functions""

function randomUnitTriangle()
    s1 = rand(Set([-1,1]))*rand(2:6)
    s2 = rand(Set([-1,1]))*rand(setdiff(2:6,[s1]))
    h = sqrt(s1^2+s2^2)
    
    if isinteger(h)
        h=Int(h)
        return ["$(latexify(s1//h,env=:raw))","$(latexify(s2//h,env=:raw))",s1/h,s2/h]
    else
        return ["\\dfrac{$(s1)}{\\sqrt{$(s1^2+s2^2)}}","\\dfrac{$(s2)}{\\sqrt{$(s1^2+s2^2)}}",s1/h,s2/h]
    end
end

#=
function tikzUnitTriangle()
    T = randomUnitTriangle()
    θ=atand(T[4]/T[3])

    """\\draw (0,0) circle (1); \\draw (0,0) -- (1,0) -- ($(T[3]),$(T[4])) -- cycle;"""
end
=#

#can adapt to a unit circle triangle by picking x=s1/h, y =s2/h.
function randomRightTriangle()
    s1 = rand(2:6)
    s2 = rand(setdiff(2:6,[s1]))
    h = sqrt(s1^2+s2^2)
    #swaps s1,s2 so that the bigger number is first
    if s1<s2
        tmp=s2
        s2=s1
        s1=tmp
    end
    if isinteger(h)
        h=Int(h)
        return ["$(s1)","$(s2)","$h"]
    else
        return ["$(s1)","$(s2)","\\sqrt{$(s1^2+s2^2)}"]
    end
end

trigFunctions = Dict{Vector,String}(
[1,3] =>"\\cos\\theta",
[2,3] =>"\\sin\\theta",
[1,2] =>"\\cot\\theta",
[2,1] =>"\\tan\\theta",
[3,1] =>"\\sec\\theta",
[3,2] =>"\\csc\\theta"
)

ratioKeys = [[1,3],[2,3],[1,2],[2,1],[3,1],[3,2]]
trigFs = ["\\cos\\theta","\\sin\\theta","\\cot\\theta","\\tan\\theta","\\sec\\theta","\\csc\\theta"]
function randomTrig()
    T = randomRightTriangle()
    givenInfo = rand(1:6)
    #selects a trig function different from givenInfo
    toFind = rand(setdiff(1:6,[givenInfo]))
    #puts the random trig function and value into ratio, and givenValue respectively
    ratio = ratioKeys[givenInfo]
    findX = trigFs[toFind]
    givenValue = [T[ratio[1]],T[ratio[2]]]
    
   println("Answer=\\dfrac{}{}")
   """\\question For an acute angle \\theta, if $(trigFs[givenInfo])=\\dfrac{$(givenValue[1])}{$(givenValue[2])}, find $(findX) (answer: \\dfrac{$(T[ratio[1]])}{$(T[ratio[2]])}"""
end

function tikzRightTriangle()
    missingSide = rand(1:3)
    tikzRightTriangle(missingSide)
end

function tikzOnlyLegs()
    tikzRightTriangle(rand(1:2))
end
function tikzRightTriangle(missingSide)
    T = randomRightTriangle()
    tStrings = string.(T)
    tStrings[missingSide]=" "
    """\\draw (0,0) -- ($(T[1]),0) node[pos=0.5,anchor=north]{$(tStrings[1])} node[pos=0.25,anchor=south]{\$\\theta\$} -- ($(T[1]),$(T[2])) node[pos=0.5,anchor=west]{$(tStrings[2])} --(0,0) node[pos=0.4,anchor=south east]{\$$(tStrings[3])\$};"""
end

#=
function quadrant()
    angles = setdiff(range())
end
=#
function makeQuiz(quiz_file,n)
        paper_io = open(quiz_file,"w");
    
        println(paper_io,raw"""
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
        \title{QUIZ 2 - RANDOMIZED}
        \begin{document}
        """)
        #header for the csv file
       # println(answers_io,"ID,x=,y=,3,4,5a1,5a2,5b(supplement)");
        #makes questions and writes to the latex file, and the .csv file
        for i in 1:n
            
            paperID= i+100
            #writing to csv file
  
            #writing to .tex file
            println(paper_io,"\\section*{Quiz 2}")
            println(paper_io,"\\subsection*{Quiz ID: $paperID}")
            println(paper_io,raw"""\makebox[0.4\textwidth]{English Name:\enspace\hrulefill}
            \vspace{0.5cm}\
            \makebox[0.4\textwidth]{Chinese Name:\enspace\hrulefill}
            \vspace{1cm}\\""")
            print(paper_io,"\\begin{questions}\n")
            println(paper_io,"\\question Find the six trigonometric functions of \$\\theta:\$")
            println(paper_io,"""
            \\begin{figure}[ht]
        \\centering
        \\begin{subfigure}{.4\\textwidth}
        \\begin{tikzpicture}
            $(tikzOnlyLegs())
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
        
    \\end{figure}""")
       #     println(paper_io,"\\makeemptybox{\\stretch{1}}")
            println(paper_io,"\\question Find the six trigonometric functions of \$\\theta:\$ ")
            println(paper_io,"""
            \\begin{figure}[ht]
        \\centering
        \\begin{subfigure}{.4\\textwidth}
        \\begin{tikzpicture}
            $(tikzRightTriangle(3))
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
    \\end{figure}""")
            #println(paper_io,"\\makeemptybox{\\stretch{1}}")
            println(paper_io,"\\newpage")
            println(paper_io,"\\section*{\\small{(Quiz ID:$(paperID))}}")
            T=randomUnitTriangle()
            println(paper_io,"
            \\question 
            Let \$p\$=\\big(\$$(T[1]),$(T[2])\$\\big) be a point on the unit circle corresponding to an angle \$\\phi\$.
                \\begin{parts} 
                    \\part What quadrant is \$p\$ in? 
                        \\makeemptybox{\\stretch{1}}
                    \\part Calculate the six trig functions of \$\\phi\$
                    \\makeemptybox{\\stretch{1}}
                    \\end{parts}
                    ")
            #new quiz
            println(paper_io,"\\end{questions}\\newpage")
        end
    
        println(paper_io,"\\end{document}")
        close(paper_io);
       # close(answers_io);
        println("success!")
end

function trial(answers_file,quiz_file)
    answers_io = open(answers_file,"w");
    paper_io = open(quiz_file,"w");

    println(paper_io,raw"""
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
            $(1)
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
            $(1)
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