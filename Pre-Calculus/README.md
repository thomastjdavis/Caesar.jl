Here is a description of each file:

In `./polynomials.jl` there are several functions that give (algebraic) data for randomly generated questions.

For example:

```
function divisionProblem(maxDegree)
    d = generatePolynomial(maxDegree)
    q = lesserDegreePolynomial(maxDegree)
    r = lesserDegreePolynomial(d[2]-1)
    f=q[1]*d+r[1]
    return (f,q,d,r)
end
```
generates a polynomial division problem where $d$ is the divisor, $q$ the quotient and $r$ the remainder.
$$\dfrac{f(x)}{d(x)}=q(x)+\dfrac{r(x)}{d(x)}$$
Or,
$$f(x)=q(x)d(x) + r(x) $$
(which is more useful for problem generation)

In `./randomTriangles.jl`, there are several functions to generate random right and unit triangles. 

In `./specialAngles.jl`, there is a function to generate questions to ask about special angles in quadrants 2 through 4.

In `Pre-Calculus/quiz*.jl` contains functions needed to generate latex code and .csv files for viewing of answer key. 
These are *not* updated yet to reflect changes to polynomials.jl (formerly `lib.jl`) (some of which are breaking changes).

