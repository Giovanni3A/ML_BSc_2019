using PyPlot

tamanho_da_amostra = 60
organize(x) = (x-1/2)*2
x1 = organize.(rand(Float32, tamanho_da_amostra))
x2 = organize.(rand(Float32, tamanho_da_amostra))
p = [rand(Float32, 1)[1], rand(Float32, 1)[1], 1]
X = [ones(length(x1)) x1 x2]
h(v, x) = sign(v'*x)

pos, neg = [], []
for i=1:tamanho_da_amostra
    r = rand(Float32,1)[1]
    if h(p, X[i,:]) >= 0
        if r < 0
            push!(neg, X[i,2:3])
        else
            push!(pos, X[i,2:3])
        end
    else
        if r < 0
            push!(pos, X[i,2:3])
        else
            push!(neg, X[i,2:3])
        end
    end
end
classificacao = Dict()
for p in pos
    classificacao[p] = 1
end
for n in neg
    classificacao[n] = -1
end
classificacao

y = [classificacao[X[i,2:3]] for i=1:tamanho_da_amostra]

function solve(X, y)
    try global A = inv(X'*X)
    catch
        return "X'X is not invertible!"
    end
    return A*X'y
end

w = solve(X, y)
for i=1:3
    println(w[i]/p[i])
end
for i=1:tamanho_da_amostra
    println(X[i,:])
    println(y[i])
    println(classificacao[X[i,2:3]])
    println(w'X[i,:])
    println("-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-")
end

title("Linear Regression")
PyPlot.clf()
PyPlot.scatter([i[1] for i in pos],[i[2] for i in pos],color="blue", label = "Positivo", s = 40)
PyPlot.scatter([i[1] for i in neg],[i[2] for i in neg],color="red", label = "Negativo", s = 40)
x = -1:0.1:1
y = (-x.*w[2] .-w[1])/w[3]
PyPlot.plot(x,y)
PyPlot.savefig("LinearRegression\\LinearRegression_Classify.pdf")
