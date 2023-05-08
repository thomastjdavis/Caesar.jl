function table()
# Define the table of values as arrays
x = [1, 2, 3, 4, 5]
f_x = rand(1:5, 5)  # Randomly generate values for f(x)
g_x = rand(1:6, 5)  # Randomly generate values for g(x)

# Initialize arrays for f(g(x)) and g(f(x))
f_g_x = zeros(Int64, 5)
g_f_x = zeros(Int64, 5)

# Populate the f(g(x)) and g(f(x)) arrays based on the table of values
for i in 1:5
    f_g_x[i] = f_x[g_x[i]]
    g_f_x[i] = g_x[f_x[i]]
end

# Print the table of values
println("Table of Values:")
println("| x | f(x) | g(x) | f(g(x)) | g(f(x)) |")
println("|---|------|------|---------|---------|")
for i in 1:5
    println("| $x[i] | $(f_x[i]) | $(g_x[i]) | $(f_g_x[i]) | $(g_f_x[i]) |")
end

# Generate problems involving compositions of functions
println("\nProblems:")
for i in 1:5
    println("Problem $i:")
    println("Calculate f(g($x[i])) = ?")
    println("Calculate g(f($x[i])) = ?")
end

# Generate answers for the problems
println("\nAnswers:")
for i in 1:5
    println("Answer $i:")
    println("f(g($x[i])) = $(f_g_x[i])")
    println("g(f($x[i])) = $(g_f_x[i])")
end
end
