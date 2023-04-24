#helper functions to pretty print tuples of the form (lengthName,$length), or (angleName,$angle) 
function length_splatt(t::Tuple{Any,Any})
    t2 = round(t[2],digits=2)
    string(t[1]," = ",t2," units")
end
function angle_splatt(t::Tuple{Any,Any})
    t2 = round(t[2],digits=2)
    string(t[1]," = ",t2," degrees")
end
function nice(a)
    round(a,digits=2)
end
#=

case 1 - 2 angles and 1 side (unique solution, called AAS/ASA)
case 2 - 2 sides and an angle oppposite one of the sides (SSA)
    no solution:
        a < b sin A=h (A acute)
        a ≤ b (A obtuse)
    one solution:
        a=b sin A =h (A acute)
        a≥ b (A acute)
        a > b (A obtuse)
    two solutions:
        b sin A < a < b (A acute)
=#
triangleNames = [("a","A"),("b","B"),("c","C")]
angleNames = ["A","B","C"]
sideNames = ["a","b","c"]
Angles = setdiff(15:170,[90])
Lengths = range(1.3,6.0,step=0.3)
#makes a obliqueTriangle with standard notation. No possibility of having a right triangle.
function obliqueTriangle()
    A = rand(Angles)
    b = rand(Lengths) 
    c = rand(setdiff(Lengths,[b]))
    a = sqrt(b^2+c^2 -2b*c*cosd(A))
    B = acosd((a^2+c^2-b^2)/(2a*c))
    C = acosd((a^2+b^2-c^2)/(2a*b))
    return ([A,a],[B,b],[C,c])
end
function graphTriangle(v)
    A=v[1][1]
    c=v[3][2]
    b=v[2][2]
    points = [(0,0),(c*cosd(A),c*sind(A)),(b,0)]
    scatter(points)
    points
end
function LSCaseI()
    v=obliqueTriangle()
    #gives two angles and a side
    excludedAngle = rand(1:3)
    includedSide = rand(1:3)
    givenAngles=[]
    for i in setdiff(1:3,[excludedAngle])
            push!(givenAngles,(angleNames[i],v[i][1]))
    end
    givenSide = (sideNames[includedSide],v[includedSide][2])
    prompt= """Solve the triangle  ABC with $(length_splatt(givenSide)), angles $(angle_splatt(givenAngles[1])), and $(angle_splatt(givenAngles[2])). """
    println(v)
    println(prompt)
end
#=
    solution_size corresponds to how many solutions exist for the specific configuration
    ie. solution_size=1 corresponds to a unique solution 
    solution_size=0 corresponds to no solutions, etc...       
        
    case 2 - 2 sides and an angle oppposite one of the sides (SSA)
    no solution:
        a < b sin A=h (A acute)
        a ≤ b (A obtuse)
    one solution:
        a=b sin A =h (A acute)
        a≥ b (A acute)
        a > b (A obtuse)
    two solutions:
        b sin A < a < b (A acute)
=#
function LSCaseII(solution_size::Int64)
    #TJ, please don't permute the names. Future TJ might murder you. 
    if solution_size==0
        A = rand(Angles)
        a = rand(Lengths)
        if A<90
            #need a < b sin A
            bMin = (a/sind(A))+0.5
            b = rand(range(bMin,bMin+4,step=0.3))
        end
        if A>90
            b = rand(range(a,a+4,step=0.3))
        end
        B=NaN
        c=NaN
        C=NaN
        prompt ="Show that there is no triangle ABC with \\angle A = $(nice(A))^{\\circ}, a=$(nice(a)) units, and b=$(nice(b)) units. "
        data=([A,a],[B,b],[C,c])
     elseif solution_size==1
        #=
        one solution:
        a=b sin A =h (A acute)
        a≥ b (A acute)
        a > b (A obtuse)
        =#
        A=rand(Angles)
        b=rand(Lengths)
        if A<90
            aMin = b*sind(A)
            a = rand(range(aMin,aMin+4,step=0.3))
        else
            a = rand(range(b+0.5,b+4.5,step=0.3))
        end
        B = asind( b/a * sind(A))
        C = 180 - (A+B)
        c = a*sind(C)/sind(A)
        data=([A,a],[B,b],[C,c])
        prompt = "Solve the triangle ABC with A=$(nice(A))^{\\circ},a=$(nice(a)) units, and b=$(nice(b)) units."
    else
        #two solutions
        # forces b/a>1, but (b/a)*sin A < 1 and A acute
        a = rand(Lengths)
        b = rand(range(a+2,a+6,step=0.3)) 
        angles = range(2,0.75*asind(a/b),length=20)
        A = rand(angles)
        B = asind((b/a)*sind(A))
        C1=180-A-B
        C2=180-A-(180-B)
        c1= (a* sind(C1)/sind(A))
        c2= (a* sind(C2)/sind(A))
        solution1=[C1,c1]
        solution2=[C2,c2]
        solutions=[solution1,solution2]
        data = ([A,a],[[B,b],[180-B,b]],solutions)
        prompt="Solve the triangle ABC, given that \$A=$A^{\\circ}\$,\$a=$a\$ units, and \$b=$b\$ units. There are two solutions."                
    end
    
    
    return (solution_size,data,prompt)
end

                
function LCCaseI()
    v=obliqueTriangle()
    prompt = "Solve triangle ABC given A=$(nice(v[1][2])) units, B=$(nice(v[2][2])) units, C=$(nice(v[3][2])) units."
    (v,prompt)
end
                
function LCCaseII()
    v=obliqueTriangle()
    includedAngle = rand(1:3)
    angleInfo = (angleNames[includedAngle],v[includedAngle][1])
    givenSides=[]
    for i in setdiff(1:3,[includedAngle])
        push!(givenSides,(angleNames[i],v[i][1]))
    end
    prompt= "Solve triangle ABC given $(angle_splatt(angleInfo)), $(length_splatt(givenSides[1])), and $(length_splatt(givenSides[2]))"
    return (v,prompt)
end
