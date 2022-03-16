choiceNames = ['A','B','C','D'];
function range(min,max){
    return Math.floor(Math.random()*(max-min+1) ) + min;
}
function excludeRange(min,max,exclusion){
    num = Math.floor(Math.random()*(max-min+1) ) + min;
    if (exclusion.includes(num)){
       num = excludeRange(min,max,exclusion);
    }
    return num;

}
function twoPoints(){
    p1 = [range(-5,5), range(-5,5)];
    p2 = [];
    let m, badM = 0;
    baddies = [range(-5,5),range(-5,5)]; 
    condition=true;
    while(condition){
        p2[0] = range(-5,5);
        p2[1] = range(-5,5);
            m = (p2[1]-p1[1])/(p2[0]-p1[0])
            if ( (p2[0]!==p1[0]) && (p2[0]!==p1[0]) && (Number.isInteger(m))){

                condition=false;
            }
    }
    if (p2[0] == p1[0]){
       m="DNE";
       b="";


    }
    else{
        m= (p2[1]-p1[1])/(p2[0]-p1[0]);
        b=p2[1]-m*p2[0];
    }
    return {
        "p1":"("+p1.toString()+")",
        "p2":"("+p2.toString()+")",
        "m":m,
        "b":b,
    }
}
function showQuestion(){
    pntQs = document.querySelectorAll("a.pointsToLine");
    pntQs.forEach(makePL);
    
    answerSheet = document.querySelector("p#answerSheet");
    //creates answer choices to select in a drop down/up list
    for(let i=0; i<pntQs.length;i++){
        qLabel = document.createElement("label")
        qLabel.title="Number "+(i+1)+"";
        qLabel.innerText=""+(i+1)+". ";
        answerSheet.appendChild(qLabel);
        selectChoices = document.createElement("select")
        selectChoices.id = "Number "+(i+1)+"";
        answerSheet.appendChild(selectChoices);
        for(let i =0; i<4; i++){
            option = document.createElement("option")
            option.value=choiceNames[i];
            option.innerText=choiceNames[i];
            selectChoices.appendChild(option);
        }
        
    }
}

function badChoices(slope,yInt){
    otherChoices = [
        {
            "b":yInt,
            "m":excludeRange(-5,5,[0])
        }
    ]
    otherChoices.push(
        {
        "b":excludeRange(-5,5,[yInt]),
        "m":slope
        });
    otherChoices.push({
        b:excludeRange(-5,5,[yInt,otherChoices[1].b]),
        m:excludeRange(-5,5,[otherChoices[0].m,slope])
    });
    return otherChoices;
}
function makePL(q){
    p=twoPoints();
    otherChoices = badChoices(p.m,p.b);
    correctChoice = range(1,4);
    //a bad choice counter
    bcc=0;
    q.innerText="Which of the following is the equation of a line between "+p.p1 +" and " + p.p2+"?";
    const choices = document.createElement("ol");
    choices.type="A"
    for(let i =0; i<4; i++){
        let choice = document.createElement("li")
      //  choice.style="padding:10px 10px;"
        if(i!==(correctChoice-1)){
            if(otherChoices[bcc].m==0){
                choice.innerText = "y = "+otherChoices[bcc].b+"";
            }else if(otherChoices[bcc].b==0){
                choice.innerText="y = "+ otherChoices[bcc].b+"";
            }
            else{
                choice.innerText= "y = "+otherChoices[bcc].m+"x + "+ otherChoices[bcc].b+""; 
            }

            
           bcc++;
        }else{
            if(p.m!==0){
                choice.innerText="y = "+p.m+"x + "+ p.b+"";
            }else if(p.b==0){
                choice.innerText="y = "+ p.b+"";
            }
            else{
                choice.innerText="y ="+p.b+"";
            }
            
        }    
        choices.appendChild(choice);
    }
    q.appendChild(choices);
    q.appendChild(document.createElement("br"));
}