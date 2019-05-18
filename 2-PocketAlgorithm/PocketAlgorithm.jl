using PyPlot

tamanho_da_amostra = 50
organize(x) = (x-1/2)*2
x1 = organize.(rand(Float32, tamanho_da_amostra))
x2 = organize.(rand(Float32, tamanho_da_amostra))
p = [organize.(rand(Float32, 1))[1], rand(Float32, 1)[1], 1]
X = [ones(length(x1)) x1 x2]

h(v, x) = sign(v'*x)

pos, neg = [], []
for i=1:tamanho_da_amostra
    r = rand(Float32,1)[1]
    if h(p, X[i,:]) >= 0
        if r < 0.1
            push!(neg, X[i,2:3])
        else
            push!(pos, X[i,2:3])
        end
    else
        if r < 0.1
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

function pegar_mal_classificado(w, X)
    v = [X[i,:] for i=1:length(X[:,1]) if classificacao[X[i,2:3]] != h(w, X[i,:])]
    if length(v) > 0
        b = rand([i for i=1:length(v)],1)
        return v[b], length(v)
    end
    return 0,0
end

function calcular_erro_interno(w, X)
    return pegar_mal_classificado(w,X)[2] / length(X[:,1])
end

W = [[.0,.0,.0]]
w_chapeu = [.0,.0,.0]

for t=1:100
    global W
    w = W[length(W)]
    x = pegar_mal_classificado(w, X)[1][1]
    if x != 0
        push!(W, w + h(p, x)*x)
    end
    if calcular_erro_interno(w_chapeu, X) > calcular_erro_interno(w, X)
        global w_chapeu = w
    end
end

title("Pocket Algorithm")
PyPlot.clf()
PyPlot.scatter([i[1] for i in pos],[i[2] for i in pos],color="blue", label = "Positivo", s = 40)
PyPlot.scatter([i[1] for i in neg],[i[2] for i in neg],color="red", label = "Negativo", s = 40)
x = -1:0.1:1
y = (-x.*w_chapeu[2] .-w_chapeu[1])/w_chapeu[3]
PyPlot.plot(x,y)
PyPlot.savefig("PocketAlgorithm\\PocketAlgorithm.pdf")

title("Internal Error Measure")
PyPlot.clf()
x = [i for i=1:length(W)]
y = [calcular_erro_interno(w, X) for w in W]
PyPlot.plot(x,y)
PyPlot.savefig("PocketAlgorithm\\InternalError.pdf")
