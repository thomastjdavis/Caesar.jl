function addParity(a)
    
    sign(a)==1 ? "+$a" : "$a"
end
function shiftedAsymptotes()
    #x=a, y=b are the correct asymptotes of \$f(x)\$
    a=rand(setdiff(-5:5,0))
    b=rand(setdiff(-5:5,0))
    
    c=rand(setdiff(-5:5,0))
    d=rand(setdiff(-5:5,0))
    questionPrompt = """
    If \$f(x)\$ has a vertical asymptote of \$x=$a\$, and a horizontal asymptote of \$y=$b\$, 
    what are the vertical and horizontal asymptotes respectively of:
    \\[f(x$(addParity(c)))$(addParity(d))\\] """
    #gives the correct asymptotes of \$f(x+c)+d\$
    correctAnswer = "x=$(a-c),\\quad y=$(b+d)"
    incorrectAnswers = ["x=$(a+c),\\quad y=$(b-d)","x=$(a-c),\\quad y=$(b-d)","x=$(a+c),\\quad y=$(b+d)"]
    return [questionPrompt,correctAnswer,incorrectAnswers]
end
#inserting mc question about asymptotes
function asymptoteQuestion(quizIO,answersIO)
    q = shiftedAsymptotes()
    correctAnswerIndex = rand(1:4)
    choiceNames = "ABCD"
    print(answersIO,"$(choiceNames[correctAnswerIndex]),")
    choices = insert!(q[3],correctAnswerIndex,q[2])
    println(quizIO, "\\question $(q[1]) \\begin{choices}")
    for i in 1:4
        println(quizIO,"""\\choice \$$(choices[i])\$""")
    end 
    println(quizIO,"""\\end{choices}""")
end
        
function asymptoteQuestion()
  q = shiftedAsymptotes()
  correctAnswerIndex = rand(1:4)
  choiceNames = "ABCD"
  choices = insert!(q[3],correctAnswerIndex,q[2])
  println("$(q[1]):")
          for i in 1:4
              println("($(choiceNames[i])) $(choices[i])")
          end
  println("The correct answer is ($(choiceNames[correctAnswerindex]))")
       
end
