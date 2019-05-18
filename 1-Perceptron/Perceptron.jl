using PyPlot

tamanho_da_amostra = 50
organize(x) = (x-1/2)*2
x1 = organize.(rand(Float32, tamanho_da_amostra))
x2 = organize.(rand(Float32, tamanho_da_amostra))
p = [organize.(rand(Float32, 1))[1], rand(Float32, 1)[1], 1]
X = [ones(length(x1)) x1 x2]

h(v, x) = sign(v'*x)

pos = [X[i,2:3] for i=1:tamanho_da_amostra if h(p, X[i,:]) >= 0]
neg = [X[i,2:3] for i=1:tamanho_da_amostra if h(p, X[i,:]) <  0]
classificacao = Dict()
for p in pos
    classificacao[p] = 1
end
for n in neg
    classificacao[n] = -1
end

function pegar_mal_classificado(p, w, X)
    v = [X[i,:] for i=1:length(X[:,1]) if classificacao[X[i,2:3]] != h(w, X[i,:])]
    if length(v) > 0
        b = rand([i for i=1:length(v)],1)
        return v[b], length(v)
    end
    return 0,0
end

w = [0, 0, 0]

numero_de_iteracoes = 0
while pegar_mal_classificado(p,w,X)[2] != 0 || numero_de_iteracoes < 1000
    x = pegar_mal_classificado(p, w, X)[1][1]
    global numero_de_iteracoes += 1
    if x != 0
        global w += h(p, x)*x
    end
end

title("Perceptron")
PyPlot.clf()
PyPlot.scatter([i[1] for i in pos],[i[2] for i in pos],color="blue", label = "Positivo", s = 40)
PyPlot.scatter([i[1] for i in neg],[i[2] for i in neg],color="red", label = "Negativo", s = 40)
x = -1:0.1:1
y = (-x.*w[2] .-w[1])/w[3]
PyPlot.plot(x,y)
PyPlot.savefig("Perceptron\\Perceptron.pdf")
