using PyPlot
# -------------------------------------------------------------
# this function allows us to generate random data where we want
# -------------------------------------------------------------
function generate_rnd(d,a,b)
    p = rand(d)
    r = zeros(d)
    for i=1:d
        r[i] = p[i]*(b-a) + a
    end
    return r
end
# -------------------
# Defining parameters
# -------------------
N = 6
test_N = 18
d = 1
a,b = -1, 1
r_interval = [i for i=0:0.0001:5]
# --------------------
# Generating some data
# --------------------
data = [generate_rnd(d,a,b) for n=1:N]
test_data = [generate_rnd(d,a,b) for n=1:test_N]
x = generate_rnd(d,a,b)
# ---------------------------
# Decide what function to use
# ---------------------------
function f(x)
    return sum([v^2 for v in x])
end
# --------------------------
# Saving values for our data
# --------------------------
S = Dict()
for n=1:N
    S[data[n]] = f(data[n])
end
test_S = Dict()
for n=1:test_N
    test_S[test_data[n]] = f(test_data[n])
end
# ------------------
# Euclidean distance
# ------------------
function distance(v1,v2)
    d = 0
    for i=1:length(v1)
        d += (v1[i]-v2[i])^2
    end
    return d^0.5
end
# ---------------
# kernel function
# ---------------
function φ(z)
    return MathConstants.e^(-(1/2)*(z^2))
end
# --------------
# alpha function
# --------------
function α(x,xn,r)
    return φ(distance(xn,x)/r)
end

function g(x,S,r)
    A = sum([α(x,xm,r) for xm in keys(S)])
    result = 0
    for p in keys(S)
        y = S[p]
        w = y/A
        result +=w*α(x,p,r)
    end
    return result
end

function find_best_r(test_S,S,r_interval)
    real_r = 0
    minor_error = 10^10
    for q in r_interval
        if q != 0
            this_r_error = 0
            for p in keys(test_S)
                this_r_error += (g(p,S,q) - test_S[p])^2
            end
            if this_r_error < minor_error
                real_r = q
                minor_error = this_r_error
            else
                if real_r != 0
                    break
                end
            end
        end
    end
    return real_r
end

r = find_best_r(test_S,S,r_interval)

# ------------------------------------
# Print data when d = 1 and regression
# ------------------------------------
if d == 1
    PyPlot.clf()
    title("Nonarametric RBF Regression")
    PyPlot.scatter([y[1] for y in x], [g(y,S,r) for y in x], color="red")
    PyPlot.scatter([p for p in keys(S)], [S[p] for p in keys(S)], color="blue")
    xlim((a,b))
    if f([a]) == f([b])
        ylim((-1,f([a])))
    else
        ylim((f([a]),f([b])))
    end
    PyPlot.savefig("np-RBF.pdf")
end
