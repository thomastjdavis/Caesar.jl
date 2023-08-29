#using Plots

function xIntProblem()
    hk = rand(setdiff(-5:5,[0,1,-1]),2)
    x_interceptX = rand(setdiff(-5:5,[0,hk[1],1,-1]))
    r1_sqrd = (hk[1]-x_interceptX)^2+(hk[2])^2

    equation1 = """(x$(niceForm(-1*hk[1])))^2+(y$(niceForm(-1*hk[2])))^2= $(r1_sqrd)"""
    if r1_sqrd-(hk[1])^2<0
        y_intercept="None"
    else
        y_intercept = [(0,"$(hk[2])+\\sqrt{$(r1_sqrd-(hk[1])^2)}"),(0,"$(hk[2])-\\sqrt{$(r1_sqrd-(hk[1])^2)}")]
    end
    (Tuple(hk),(x_interceptX,0),equation1,y_intercept)
end
function yIntProblem()
    hk = rand(setdiff(-5:5,[0,1,-1]),2)
    y_interceptY = rand(setdiff(-5:5,[0,hk[2],1,-1]))
    r1_sqrd = (hk[1])^2+(hk[2]-y_interceptY)^2

    equation1 = """(x$(niceForm(-1*hk[1])))^2+(y$(niceForm(-1*hk[2])))^2= $(r1_sqrd)"""
    if r1_sqrd-(hk[2])^2<0
        x_intercept="None"
    else
        x_intercept = [("$(hk[1])+\\sqrt{$(r1_sqrd-(hk[2])^2)}",0),("$(hk[1])-\\sqrt{$(r1_sqrd-(hk[2])^2)}",0)]
    end
    (Tuple(hk),(0,y_interceptY),equation1,x_intercept)
end
function niceForm(a::T where T<:Number)
    #gives
    if a==one(typeof(a))
        return ""
    elseif a==-1*one(typeof(a))
        return "-"
    elseif a<0
        return string("-",abs(a)) 
    else
        return string("+",a)
    end
end

function makeData()
    n=20
    io = open("circleInterceptData.tsv","w")
    #prints headers
    print(io,"ID\tOriginal Center\t (x or y)-intercept\t Equation of the circle\t (y or x)-intercepts (if any)\n ")
    for i in 1:n
        xInt = xIntProblem()
        print(io,string(i,"\t $(xInt[1])\t$(xInt[2])\t$(xInt[3])\t$(xInt[4])\n"))
        yInt=yIntProblem()
        print(io,"\t $(yInt[1])\t$(yInt[2])\t$(yInt[3])\t$(yInt[4])\n")
    end
    close(io)
end