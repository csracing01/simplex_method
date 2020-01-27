# simplex_method
Simplex Method Implementation in MATLAB

The file "tableau.m" performs a single step of pivoting. The input is a feasible simplex tableau to be read from an input file. The program outputs the entering and leaving variable indices.

The tableau is to be encoded in the input file as follows:
•	The first row mentions the number of basic variables (say m)and non-basic variables (say n) separated by space
•	The second row specifies space separated indices of the basic variables
•	The third row specifies space separated indices of the non-basic variables
•	The fourth row specifies bi’s
•	Next m number of rows correspond to the coefficient matrix A
•	The last row has vector z (the first element being z0)

For instance, interpretation of the following input file is given below:
3 4
1 3 6
2 4 5 7
1 3 0
0 0 -1 -2
1 -1 0 -1
-1 0 -2 0
1 -1  2 3 1

X1	1			-1 X5	-2 X7
X3	3	+1 X2	-1 X4		-1 X7
X6	0	-1 X2		-2 X5	
z	1	-1 X2	+2 X4	+3 X5	+1 X7

The file "simplex.m" implements whole simplex method given initial tableau as feasible (all non-negative values).
