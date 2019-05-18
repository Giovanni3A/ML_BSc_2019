include("Cluster\\k-cluster.jl")
using PyPlot, .Cluster

n = 2000
k = 5
data = []

for i=1:n
    dx,dy = rand(2)
    dx, dy = (dx-0.5)/3, (dy-0.5)/3
    if i <= n/4
        x,y = 0.25,0.25
    elseif i <= 2*n/4
        x,y = 0.75,0.25
    elseif i <= 3*n/4
        x,y = 0.25,0.75
    else
        x,y = 0.75,0.75
    end
    push!(data, [x+dx,y+dy])
end

clusterized = Cluster.k_cluster(k,data)

PyPlot.clf()
PyPlot.scatter([j[1] for j in data],[j[2] for j in data], color="blue", s=30)
PyPlot.scatter([i[1] for i in clusterized],[i[2] for i in clusterized], color="red", s=50)
PyPlot.xlim((0,1))
PyPlot.ylim((0,1))
PyPlot.savefig("D:\\Personal\\EMAp\\Machine Learning\\hehehe505.pdf")

data
