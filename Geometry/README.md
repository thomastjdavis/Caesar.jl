Here is a overview:

ArbitraryTriangles.jl contains functionality to make oblique triangles and problems associated with solving them, namely using the law of Sines and Cosines.

`obliqueTriangle()` is a oblique triangle that returns the values [Angle,Side] for the three sides of a triangle.

`LSCaseI(), LSCaseII()` give information for a problem involving case I (AAS) or case II (SSA) of the Law of Sines. Law of Sines here:

\[\dfrac{\sin A}{a}=\fdrac{\sin B}{b}=\dfrac{\sin C}{c}\]

For reference, AAS guarantees a unique solution, because $180^{\circ}=a+b+c$ so you can always find the third angle.

SSA is more complex, giving either 0, 1, or 2 distinct solutions. The comments contain notes to explain this.

`LCCaseI(), LCCaseII()` give information for a problem involving case I (SSS) or case II (SAS) of the Law of Cosines. Law of Cosines:
\[c^2 = a^2 + b^2 -2ab\cos C\]
