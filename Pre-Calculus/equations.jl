using Polynomials

function expandLogs()
    powers = rand(2:6,3)
    expr = "\\[\\ln u^{$(powers[1])}v^{$(powers[2])}w^{$(powers[3])}\\]"
    answer =  "$(powers[1])ln(u)+$(powers[2])ln(v)+$(powers[3])ln(w)"
    return (expr,answer)
end
function extraSolutions()
    a = rand(1:5)
    b = rand(-5:-1)
    base = rand(2:10)
    p = fromroots([a,b])
    println(p)
    second_term = Polynomial([-a-b,1])
    ("x", second_term,"a=$a","b=$b" )
    #need log_base(x)+log_base(second_term)=log_base(a*b)
    ("\\log_{$(base)}{x}+\\log_{$(base)}{\\left($(second_term)\\right)}=\\log_{$(base)}{$(-1*a*b)}","a=$a","b=$b" )
    
end