using Random

eighths=["\\dfrac{3\\pi}{4}","\\dfrac{5\\pi}{4}","\\dfrac{7\\pi}{4}"]
thirds=["\\dfrac{2\\pi}{3}","\\dfrac{4\\pi}{3}","\\dfrac{5\\pi}{3}"]
sixths=["\\dfrac{5\\pi}{6}","\\dfrac{7\\pi}{6}","\\dfrac{11\\pi}{6}"]

species = [eighths,thirds,sixths]

function specialAngle(questionIO)
    quadrants = randperm(3)
    println(quadrants)
    for index in 1:3
        println(questionIO,"\\question[2] Give the values of \$\\sin\\theta\$ and \$\\cos\\theta\$ for \$\\theta=$(species[quadrants[index]][index])\$ \\makeemptybox{\\stretch{1}}")
    end
end