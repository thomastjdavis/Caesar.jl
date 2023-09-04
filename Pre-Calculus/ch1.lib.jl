using Latexify, Random, RationalGenerators, SymEngine
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
function initialSegment(a::T where T<:Integer)
    if a==one(typeof(a))
        return ""
    elseif a==-1*one(typeof(a))
        return "-"
    elseif a<0
        return string("-",abs(a)) 
    else
        return string(a)
    end
end

function distinctPoints()
    p1 = rand(-5:5,2)
    p2x=rand(setdiff(-5:5,p1[1]))
    p2y=rand(setdiff(-5:5,p1[2]))
    
    p2=[p2x,p2y]
    (p1,p2)
end

function midpoint()
    points = distinctPoints()
    md = [(points[1][1]+points[2][1]),(points[1][2]+points[2][2])].//2
    (points,md)
end
function midpointQuestion()
    mdData = midpoint()
    prompt = """\\question Calculate the midpoint of the points \$ p_1=$(Tuple(mdData[1][1])) \$ and \$p_2=$(Tuple(mdData[1][2]))\$\\makeemptybox{\\stretch{1}}"""
    (prompt,Tuple(mdData[2]))
end

function distanceFormula()
    points = distinctPoints()
    Δx = (points[1][1]-points[2][1])
    Δy = (points[1][2]-points[2][2])
    distanceSquared = (Δx)^2+(Δy)^2
    if round(sqrt(distanceSquared))==sqrt(distanceSquared)
        distanceString = string(Int64(sqrt(distanceSquared)))
    else 
        distanceString = """\\sqrt{$(distanceSquared)}"""
    end
    (points,sqrt(distanceSquared),distanceString)
end

function distanceQuestion()
    distData = distanceFormula()
    prompt = """\\question Calculate the distance between the points \$ p_1=$(Tuple(distData[1][1])) \$ and \$p_2=$(Tuple(distData[1][2]))\$\\makeemptybox{\\stretch{1}}"""
    (prompt,string(distData[2], " or ",distData[3], " units"))
end

function linear_intercepts()   
    a=rand(setdiff(-5:5,[0,1]))
    b=rand(setdiff(-5:5,[0,a,1]))
    c=rand(setdiff(-5:5,[0]))
    
    x_intercept = (c//a,0)
    y_intercept = (0,c//b)
    expr = "$(initialSegment(a))x$(niceForm(b))y = $(c)"
    (expr,[a,b,c],x_intercept,y_intercept)
end

function linear_interceptQuestion()
    liData = linear_intercepts()
    prompt = """
    \\question What is the x-intercept and the y-intercept of the following equation:
    \\[$(liData[1]) \\]
    \\makeemptybox{\\stretch{1}}
    """
    (prompt,liData[3],liData[4])
end

function circle_equation()
    center  = rand(setdiff(-5:5,[0,1,-1]),2)
    radius = rand(2:10)
    correct = "\$(x$(niceForm(-center[1])))^2+(y$(niceForm(-center[2])))^2=$(radius^2)\$"
    (correct,center,radius)
end

function circleMC()
    questionData = circle_equation()
    center = questionData[2]
    radius = questionData[3]
    prompt = "\\question The equation of a circle of radius $(questionData[3]), centered at the point $(Tuple(center)) is: \\begin{choices}"
    incorrect1 = "\$(x$(niceForm(questionData[2][1])))^2+(y$(niceForm(-questionData[2][2])))^2=$(radius^2)\$"
    incorrect2= "\$(x$(niceForm(-questionData[2][1])))^2+(y$(niceForm(questionData[2][2])))^2=$(radius^2)\$"
    incorrect3= "\$(x$(niceForm(questionData[2][1])))^2+(y$(niceForm(questionData[2][2])))^2=$(radius^2)\$"
    correctChoice = rand(1:4)
    permutedAnswers = shuffle([incorrect1,incorrect2,incorrect3])
    j=1
    for i in 1:4
        if i==correctChoice
            prompt = prompt*"\\choice"*questionData[1]
        else
            prompt = prompt *"\\choice" *permutedAnswers[j]
            j=j+1
        end

    end
    prompt = prompt * "\\end{choices}"
    choices = ["A","B","C","D"]
    (prompt,choices[correctChoice])
end
#=
TO DO:
MC conversion
    make more mc friendly questions
Linear Equations
    parallel/perpendicular/none of above
    slope from points
    line from intecepts
=#

#=
putting into symbolicCalcs
function slopePoint()
    slopes = collect((t for t in SmallRatGen(5) if t<1))
    slope = rand(slopes)
    point = rand(setdiff(-5:5,[0,1]),2)
    prompt = "Write an equation of a line passing through the point $(Tuple(point)) with slope \$m\$=$(latexify(slope))"
    slopeIntercept ="""\$y=$(latexify(slope))m$(niceForm(point[2]-slope*point[1])) \$"""
    return """$prompt    $slopeIntercept"""
end=#

function cumcircle()
    data = midpointQuestion()
    "Points p=$(data[1])"
end

function linearExtrapolation()
    slopes = [t for t in RationalGenerator(10) if denominator(t)!=1]
    slope = rand(slopes)
    x0 = rand(setdiff(-5:5,[0]))
    fx0 = rand(10:20)
    function line(x)
        slope*(x-x0)+fx0
    end
    x1 = x0+ denominator(slope)
   fx1 = Int64(line(x1))
    x_minus1 = x0-denominator(slope)
    fx_1 = Int64(line(x_minus1))
    newpoint = rand(setdiff((x_minus1+1):(x1-1),[x0]))
    (slope,(x_minus1,fx_1),(x0,fx0),(x1,fx1),(newpoint,line(newpoint)))
end

function linearExtrapolationVectorized()
    slopes = [t for t in RationalGenerator(10) if denominator(t)!=1]
    slope = rand(slopes)
    x0 = rand(setdiff(-5:5,[0]))
    fx0 = rand(10:20)
    function line(x)
        slope*(x-x0)+fx0
    end
    x1 = x0+ denominator(slope)
   fx1 = Int64(line(x1))
    x_minus1 = x0-denominator(slope)
    fx_1 = Int64(line(x_minus1))
    newpoint = rand(setdiff((x_minus1+1):(x1-1),[x0]))
    [slope,[[x_minus1,fx_1],[x0,fx0],[x1,fx1],[newpoint,line(newpoint)]]]
end
function linearExtrapolationQuestion()
    q=linearExtrapolation()
    table = """
    \\begin{centering}
    Use the following table to answer question 3.
    \\end{centering}
    \\begin{table}[h]
        \\centering
        \\resizebox{0.3\\textwidth}{!}{%
            \\begin{tabular}{|l|l|l|l|}
            \\hline
            \\textbf{\$x\$}    & $(q[2][1])  & $(q[3][1])   & $(q[4][1])  \\\\ \\hline
            \\textbf{\$f(x)\$} & $(q[2][2]) & $(q[3][2]) & $(q[4][2]) \\\\ \\hline
            \\end{tabular}%
            }
    \\end{table} """
    prompt="$table \n\\question If \$f(x)\$ is a linear function, what is the value of \$f($(q[5][1]))\$?\\makeemptybox{\\stretch{1}} "
    (prompt,q[5][2])
end

function slopeFromPoints()
    pair = distinctPoints()
    slope = (pair[2][2]-pair[1][2])//(pair[2][1]-pair[1][1])
    (pair,slope)
end

function slopeFromPointsQuestion()
    data = slopeFromPoints()
    prompt = """\\question Calculate the slope between the two points:
    \\[p_1=$(Tuple(data[1][1]))\\]
    \\[p_2=$(Tuple(data[1][2]))\\] 
    \\makeemptybox{\\stretch{1}}"""
    (prompt,data[2])
end

