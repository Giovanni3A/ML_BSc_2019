using PyPlot

tamanho_da_amostra = 60
organize(x) = (x-1/2)*2
p = [organize.(rand(Float32, 1))[1], 1]
x1 = organize.(rand(Float32, tamanho_da_amostra))
X = [ones(length(x1)) x1]
y = [p'*X[i,:] + organize(rand(1)[1]) for i=1:tamanho_da_amostra]

function solve(X, y)
    try global A = inv(X'*X)
    catch
        return "X'X is not invertible!"
    end
    return A*X'y
end

w = solve(X, y)

title("Linear Regression")
PyPlot.clf()
PyPlot.scatter(X[:,2], y, color="green", label = "Positivo", s = 40)
a = -1:0.1:1
b = a.*w[2] .+w[1]
PyPlot.plot(a,b)
PyPlot.savefig("LR.pdf")

X[:,2]
y

function LinReg(X,Y)
    try global A = inv(X'*X)
    catch
        return "X'X is not invertible!"
    end
    return A*X'Y
end
