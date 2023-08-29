function sales()
    start_year = rand(1900:1990)
    years = start_year:(start_year+6)
    initial_value = rand(110:0.2:200)
    y=[initial_value]
    directions = [1,-1]
    for i in 1:(length(years)-1)
        current_direction = rand(directions)
        #increases the chance that the oppposite change will happen
        push!(directions,-1*current_direction)
        step = current_direction*0.2*y[i]
        push!(y,y[i]+step)
    end
    y=round.(y,digits=2)
    (Vector(years),y)
end
#creates data about the rates of change between adjacent years 
#s=sales()
function rates(s)
    initial_year = s[1][1]
    #length 7 Vector

end

#creates a plot from s=sales()
function plotSales(s)
    p=plot(s,legend=:false)
    scatter!(p,s,color=:blue)
    p
end
#creates a table from s=sales()
function latexifySales(s)
    table = """\\begin{table}
    \\begin{tabular}{ll}
    Year     & Number of Sales (Thousands) \\\\ \\hline
    """
    y = s[1]
    for i in 1:7
        table=table * string(s[1][i]) * " & " * string(s[2][i])
        if i != 7
            table = table*"\\\\"
        end
    end
    table = table * "\\end{tabular}\\end{table}"
    table
end

function saleTrial()
    localS = sales()
    p=plotSales(localS)
    savefig(p,"plot.png")
    table = latexifySales(localS)
    io = open("file.tex","w")
    println(io,raw"""\documentclass{article}
    \usepackage{graphicx}
    \graphicspath{{.}}
    \title{trial}
    \begin{document}
    \begin{figure}[h]
    \includegraphics[width=\textwidth]{plot.png}
    \end{figure}
    """)
    println(io,table)
    println(io,raw"""\end{document} """)
    close(io)
    run(`pdflatex file.tex`)
end