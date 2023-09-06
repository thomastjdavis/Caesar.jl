function cubeRoot()
    num = rand(setdiff(4.5:0.5:9.5,[8.0]))
    correctChoice = rand(1:4)
    value = (num)^(1/3)
    (num,value,correctChoice,calculation(value,correctChoice))
end

function mcCalculation()::Tuple{String,Char}
    data = cubeRoot()
    prompt = "\\question \\[\\biggl($(data[1])\\biggr)^{\\dfrac{1}{3}}\\approx?\\]\\begin{choices}"
    for i in 1:4
        prompt=prompt*"\\choice ($(data[4][i]))"
    end
    prompt=prompt*"\\end{choices}"
    choices = ['A','B','C','D']
    (prompt,choices[data[3]])
end

function orderedTolerance(correctIndex,value,index)
    tolStep = 0.05
    if index==correctIndex
        return round(value,digits=3)
    else
        return round((1+(index-correctIndex)tolStep)value,digits=3)
    end
end

function calculation(value,correctIndex)
    answers=[]
    for i in 1:4
        push!(answers,orderedTolerance(correctIndex,value,i))
    end
    answers
end

