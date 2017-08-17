# --------------------------------------------
# this file is part of PFlow.jl
# it implements the file IO functions
# --------------------------------------------
# author: Paul Bayer, Paul.Bayer@gleichsam.de
# --------------------------------------------
# license: MIT
# --------------------------------------------

"""
    readWorkunits(file::AbstractString)

read the workunits from a .csv file, start the processes
and return a Dict of the workunits.
"""
function readWorkunits(file::AbstractString, sim::Simulation, log::Simlog)
    t = readtable(file)
    d = Dict{String, Workunit}()
    for i ∈ 1:nrow(t)
        wu = workunit(sim, log, t[i,3], t[i,1], t[i,2], t[i,4], t[i,5], t[i,6],
                      t[i,8], t[i,9], t[i,7], t[i,10])
        d[t[i,1]] = wu
    end
    d
end

"""
    readOrders(file::AbstractString)

read the orders from a .csv file and return a Dict of the orders/jobs
"""
function readOrders(file::AbstractString)
    t = readtable(file)
    d = Dict{String, Array{Job,1}}()
    for o ∈ Set(t[:order])
        t1 = t[t[:order] .== o, :]
        for i ∈ 1:nrow(t1)
            job = Job(o, t1[i,2], split(t1[i,3],","), t1[i,4], 0.0, 0.0,
                      OPEN, t1[i,5], isna(t1[i,6]) ? "" : t1[i,6])
            if haskey(d, o)
                push!(d[o], job)
            else
                d[o] = [job]
            end
        end
    end
    d
end