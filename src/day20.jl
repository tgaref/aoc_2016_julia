using CombinedParsers

function readinput(file)
    rangeP = Sequence(Numeric(Int), "-", Numeric(Int)) do t
        (t[1], t[3])
    end
    data = Tuple{Int, Int}[]
    for line in eachline(file)
        push!(data, parse(rangeP, line))
    end
    data       
end

function nextips(data)
    current = data[1]
    for (j, (x,y)) in enumerate(data[2:end])
        x > current[2]+1 && return (x-current[2]-1, @view data[j+1:end]) 
        current = (current[1], max(current[2], y))        
    end
    (4294967295 - current[2], [])
end

function day20a()
    data = readinput("../inputs/20.input")
    sort!(data; by = first)
    current = data[1]
    for (x,y) in data[2:end]
        x > current[2]+1 && return current[2]+1
        current = (current[1], max(current[2], y))        
    end
end

function day20b()
    data = readinput("../inputs/20.input")
    sort!(data; by = first)
    cnt = data[1][1] > 0 ? 1 : 0        
    i = 1
    while length(data) > 0
        (c,data) = nextips(data)
        cnt += c        
    end
    cnt
end
