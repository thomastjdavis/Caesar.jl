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
signs = [[1,1],[1,-1],[-1,-1],[-1,1]]
function tancotSign(quadrant)
    s=signs[quadrant]
    s[1]*s[2]
end

function neg(s)
    s == 1 ? ">0" : "<0" 
end

#TO DO - make correct. Code looks stupidly messy
function randomTrig()
    T = randomRightTriangle()
    quadrant = rand(2:4)

    if quadrant==2
        T[2]="-"*T[2]
        T[3]="-"*T[3]
    end
    if quadrant==3
        T[2]="-"*T[2]
        T[1]="-"*T[1]
    end
    if quadrant==4
        T[1]="-"*T[1]
        T[3]="-"*T[3]
    end
    #do stuff 
    givenInfo = rand(1:6)
    givenKey = ratioKeys[givenInfo]
    givenRatio = [T[givenKey[1]],T[givenKey[2]]]
    #selects a trig function different from givenInfo
    toFind = rand(setdiff(1:6,[givenInfo]))
    #gives a clue to indicate which quadrant
    signClue = rand(setdiff(1:6,[givenInfo,toFind]))
    #puts the random trig function and value into ratio, and givenValue respectively
    secretRatio = ratioKeys[toFind]
    

    findX = trigFs[toFind]
    secretValue = [T[secretRatio[1]],T[secretRatio[2]]]
    

   print("""
   \\question For an angle \\theta, if $(trigFs[givenInfo])=\\dfrac{$(givenRatio[1])}{$(givenRatio[2])}, 
   and \$$(trigFs[signClue])$(neg(s))\$, 
   find $(findX) 
   (answer: \\dfrac{$(secretValue[1])}{$(secretValue[2])})"""
   )
   #returning a tuple of the information 
   # givenFunction, givenData for function, functionToFind, secretRatio
   return (trigFs[givenInfo],"\$\\dfrac{$(givenRatio[1])}{$(givenRatio[2])}\$",findX,"\\dfrac{$(secretValue[1])}{$(secretValue[2])")
end

function randomAcuteTrig()
    T = randomRightTriangle()
    givenInfo = rand(1:6)
    givenKey = ratioKeys[givenInfo]
    givenRatio = [T[givenKey[1]],T[givenKey[2]]]
    #selects a trig function different from givenInfo
    toFind = rand(setdiff(1:6,[givenInfo]))
    #puts the random trig function and value into ratio, and givenValue respectively
    secretRatio = ratioKeys[toFind]

    findX = trigFs[toFind]
    secretValue = [T[secretRatio[1]],T[secretRatio[2]]]
   

   
   #returning a tuple of the information 
   # givenFunction, givenData for function, functionToFind, secretRatio
   return (trigFs[givenInfo],"\\dfrac{$(givenRatio[1])}{$(givenRatio[2])}",findX,"\\dfrac{$(secretValue[1])}{$(secretValue[2])}")
end

function acuteRandom(paperIO,answerIO)
    T =randomAcuteTrig()

    println(paperIO,"""\\question For an angle \$\\theta\$ in quadrant I , if \$ $(T[1])=$(T[2])\$ find \$ $(T[3]) \$\\makeemptybox{\\stretch{1}}""")
    print(answerIO,"$(T[4])")

end

function acuteTrigProblem(paperIO,answerIO)
    T = randomAcuteTrig()
    println(paperIO,"""\\question For an acute angle \\theta, if $(T[1])=$(T[2]), find $(T[3])\\makeemptybox{\\stretch{1}}""")
    print(answerIO,T[4])
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
