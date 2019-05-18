using PyPlot
# ------------------------------------------------
# Deciding the 'original' line that separates data
p1,p2 = rand(2),rand(2)
m = (p2[2]-p1[2])/(p2[1]-p1[1])
k = (p2[1]*p1[2] - p1[1]*p2[2])/(p2[1] - p1[1])
# y = mx + k: > --> 1 /\ < --> -1
# ------------------------------------------------
# Generate data
n_data, p0 = 100, 0.05
datax, datay = rand(n_data), rand(n_data)
data = zeros(n_data)
for i=1:n_data
    p = rand(1)[1]
    if datay[i] >= m*datax[i] + k
        if p >= p0
            data[i] = 1
        else
            println("aqui")
            data[i] = -1
        end
    else
        if p >= p0
            data[i] = -1
        else
            println("aqui")
            data[i] = 1
        end
    end
end
# ------------------------------------------------
# Define new point and a value to it
x,y = rand(2)

function distance(v1,v2)
    d = 0
    for k=1:length(v1)
        d += (v1[k]-v2[k])^2
    end
    return d^0.5
end

function closest_neighbor(neighbors,point)
    x,y = point
    min_dist, j = 10^10, 0
    for i=1:length(neighbors)
        dist = distance(neighbors[i],[x,y])
        if dist < min_dist
            min_dist = dist
            j = i
        end
    end
    return j
end

neighbors = [[datax[i],datay[i]] for i=1:n_data]
g = data[ closest_neighbor(neighbors, [x,y])]
# ------------------------------------------------
# Print data divided
title("NN")
PyPlot.clf()
if g == 1
    color = "green"
else
    color = "yellow"
end
PyPlot.scatter([x],[y],color=color,s = 50)
PyPlot.scatter([datax[i] for i=1:n_data if data[i]==1],[datay[i] for i=1:n_data if data[i]==1],color="blue", label = "Positivo", s = 40)
PyPlot.scatter([datax[i] for i=1:n_data if data[i]==-1],[datay[i] for i=1:n_data if data[i]==-1],color="red", label = "Negativo", s = 40)
x = -1:0.1:1
y = x.*m .+k
PyPlot.plot(x,y)
xlim((0,1))
ylim((0,1))
PyPlot.savefig("NN.pdf")
# ------------------------------------------------
