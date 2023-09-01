section3 = [
    ("linear equation", "线性方程"),
    ("slope", "斜率"),
    ("slope-intercept form of a line", "直线的斜截式"),
    ("vertical line", "垂线"),
    ("undefined slope", "未定义斜率"),
    ("point-slope form", "点斜式"),
    ("parallel lines", "平行线"),
    ("perpendicular lines", "垂直线"),
    ("rate of change", "变化率")
]

section4 = [
    ("function", "函数"),
    ("domain", "域"),
    ("range", "值域"),
    ("input", "输入"),
    ("output", "输出"),
    ("independent variable", "自变量"),
    ("dependent variable", "因变量"),
    ("function notation", "函数表示法"),
    ("piecewise-defined function", "分段函数"),
    ("implied domain", "隐含域"),
    ("Infinity", "无穷大")
]

section5 = [
    ("zero of a function", "函数的零点"),
    ("increasing", "递增"),
    ("decreasing", "递减"),
    ("constant", "常数"),
    ("relative minimum", "相对最小值"),
    ("relative maximum", "相对最大值"),
    ("average rate of change", "平均变化率"),
    ("even function", "偶函数"),
    ("odd function", "奇函数")
]

section6 = [
    ("parent function", "父函数"),
    ("family of functions", "函数族"),
    ("constant function", "常函数"),
    ("squaring/quadratic function", "平方/二次函数"),
    ("cubic function", "立方函数"),
    ("square root function", "平方根函数"),
    ("step function", "阶跃函数"),
    ("reciprocal function", "倒数函数")
]

section7 = [
    ("shift/translation", "平移"),
    ("vertical shift", "垂直平移"),
    ("horizontal shift", "水平平移"),
    ("reflection in the x-axis", "X轴对称反射"),
    ("reflection in the y-axis", "Y轴对称反射"),
    ("non-rigid transformations", "非刚性变换"),
    ("[direction] stretch", "[方向]拉伸"),
    ("[direction] shrink", "[方向]收缩")
]

section8 = [
    ("operations with functions", "函数的运算"),
    ("add functions", "函数相加"),
    ("subtract functions", "函数相减"),
    ("multiply functions", "函数相乘"),
    ("divide functions", "函数相除"),
    ("quotient of functions", "函数的商"),
    ("composition of functions", "函数的复合")
]

section9 = [
    ("inverse functions", "反函数"),
    ("horizontal line test", "水平线测试"),
    ("one-to-one functions", "一对一函数"),
    ("reflection over a line", "线对称反射")
]

function totalList(section::Int64)
    #catches input errors
    if section <=0
        error("section must be greater than zero, value of section = $(section)")
    end
    list = Base.eval("section$(section)")
    eval(Meta.parse(list))
end


function totalLists(sections::Vector{Int64})
    v=[]
    for section in sections
        miniList = totalList(section)
        v=[v;miniList]
    end
    v
end

totalList(s::Vector{Int64})=totalLists(s)

function quizVocab(sections::Vector{Int64})
    #how many questions will be on the quiz
    vocabLength = 5
    vocabList = totalList(sections)
    indices = []

    table = """\\begin{table}\\centering
    \\resizebox{0.4\\columnwidth}{!}{%
        \\begin{tabular}{|l|l|}
        \\hline
English Word & \\chinese{中文}   \\\\ \\hline"""
    englishWords = []
    for i in 1:vocabLength
        go_to_next = false
        while !go_to_next
            #checks if index chosen is in indices
            value = rand(1:length(vocabList))
            if value∉indices
                push!(indices,value)
                push!(englishWords,vocabList[value][1])
                table = table * """\n & \\chinese{$(vocabList[value][2])} \\\\ \\hline """
                go_to_next=true
            end
        end
        

    end
    table = table*"""\\end{tabular}%
    }
    
    \\label{tab:my-table}
    \\end{table}"""
    (table,Vector{String}(englishWords))
end

function trial()
    paper_io = open("trial.tex","w")
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
    for i in 1:7
        v = quizVocab([3,4])
        println(paper_io,v[1])
        println(paper_io,string(v[2],"\n"))
    end
    println(paper_io,"\\end{document}")
    close(paper_io)
    run(`pdflatex trial.tex`)

    run(`pdflatex trial.tex`)

end