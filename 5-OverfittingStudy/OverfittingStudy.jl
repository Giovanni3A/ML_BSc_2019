using Distributions, PyPlot

# LegendrePolynomials = Dict(0 => [0,0,0,0,0,0,0,0,0,0,1],
#                            1 => [0,0,0,0,0,0,0,0,0,1,0],
#                            2 => [0,0,0,0,0,0,0,0,3,0,-1]/2,
#                            3 => [0,0,0,0,0,0,0,5,0,-3,0]/2,
#                            4 => [0,0,0,0,0,0,35,0,-30,0,3]/8,
#                            5 => [0,0,0,0,0,63,0,-70,0,15,0]/8,
#                            6 => [0,0,0,0,231,0,-315,0,105,0,-5]/16,
#                            7 => [0,0,0,429,0,-693,0,315,0,-35,0]/16,
#                            8 => [0,0,6435,0,-12012,0,6930,0,-1260,0,35]/128,
#                            9 => [0,12155,0,-25740,0,18018,0,-4620,0,315,0]/128,
#                            10 => [46189,0,-109395,0,90090,0,-30030,0,3465,0,-63]/256)

LegendreFunction(n,x) = (1/2^n)*sum([(binomial(n,k)^2)*((x-1)^(n-k))*((x+1)^k) for k=0:n])
# LegendreFunction(n,x) = reverse(LegendrePolynomials[n])'*[x^i for i=0:10]

f(x, α, Qf) = sum([α[j+1]*LegendreFunction(j,x) for j=0:Qf])

d = Normal(0,1)
u = Uniform(-1,1)

function Generate(Qf, N, σ)
    Efsqr = sum([1/(2*q + 1) for q=0:Qf])
    α = rand(d, Qf+1)
    ϵ = rand(d, N)
    X = rand(u, N)
    Y = [f(x, α, Qf)/Efsqr^0.5 for x in X] + σ*ϵ
    return X,Y
end

# function Generate(Qf, N, σ)
#     α = rand(d, Qf+1)
#     Efsqr = sum([(α[q+1]^2)/(2*q + 1) for q=0:Qf])
#     ϵ = rand(d, N)
#     X = rand(u, N)
#     Y = [f(x, α, Qf)/Efsqr^0.5 for x in X] + σ*ϵ
#     return X,Y
# end

function LinReg(X,Y)
    try global A = inv(X'*X)
    catch
        return "X'X is not invertible!"
    end
    return A*X'Y
end

function Solve(n, X, Y)
    arr = zeros(length(X), n+1)
    for c = 1:n+1, l=1:length(X)
        arr[l,c] = X[l]^(c-1)
    end
    LR = LinReg(arr, Y)
    while typeof(LR) == String
        LR = LinReg(arr, Y)
    end
    return LR
end

a=[1,2,3,4]
a.^2

#= Plotting.............................................................................................................................. #
Qf, N, σ = 20, 100, 0

X,Y = Generate(Qf,N,σ)
H2 = Solve(2, X, Y)
H10 = Solve(10, X, Y)

title("Study")
PyPlot.clf()
PyPlot.scatter(X, Y, color="blue", label = "Positivo", s = 40)
a = -1:0.01:1
b2 = sum([H2[i+1]*a.^(i) for i=0:2])
b10 = sum([H10[i+1]*a.^(i) for i=0:10])
PyPlot.plot(a, b2, color="green")
PyPlot.plot(a,b10, color="red")
# ax = gca()
# ax[:set_ylim]([-5,5])
PyPlot.savefig("ExamplePlot.pdf")
# ....................................................................................................................................... =#

function start(Qf,N,σ)
    N_Total = 40
    G = Generate(Qf, N+N_Total, σ)
    X, Y = G[1][1:N], G[2][1:N]
    H2 = Solve(2, X, Y)
    H10 = Solve(10, X, Y)

    XTests, YTests = G[1][N+1:N+N_Total], G[2][N+1:N+N_Total]
    Tests = (XTests, YTests)
    Error2, Error10 = 0, 0
    for xy in Tests
        x,y = xy[1], xy[2]
        value2, value10 = 0, 0
        for k=1:3
            value2 += H2[k]*(x^(k-1))
        end
        Error2 += (value2 - y)^2
        for k=1:11
            value10 += H10[k]*(x^(k-1))
        end
        Error10 += (value10 - y)^2
    end
    Error2 = (Error2^0.5)/N_Total
    Error10 = (Error10^0.5)/N_Total
    return Error10 - Error2
end

start(20, 200, 0)
sum(start(20,200,0) for i=1:100)/100

Qf = 20
results1= zeros(31,100)
for σ=0:0.05:0.0, N=51:60
    println("Para: σ = ", σ, ", N = ", N)
    e = 0
    for i=1:100
        s = start(Qf,N,σ)
        while s^2 > 1
            s = start(Qf,N,σ)
        end
        e += s/100
    end
    println("Erro encontrado = ", e)
    global results1[ceil(Int,σ/0.05) + 1, N-50] = e
end

results1
