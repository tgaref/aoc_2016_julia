
function readinput(file)
    data = String[]
    for line in eachline(file)
        push!(data, line)
    end
    data
end

function day6a()
    data = readinput("../inputs/6.input")
    freq = [Dict{Char, Int}() for _ in 1:8]
    for line in data
        for (i,c) in enumerate(line)            
            freq[i][c] = get(freq[i], c, 0) + 1
        end
    end

    for f in freq
        sort(collect(f); by = last, rev = true)[1] |> first |> print
    end
end

function day6b()
    data = readinput("../inputs/6.input")
    freq = [Dict{Char, Int}() for _ in 1:8]
    for line in data
        for (i,c) in enumerate(line)            
            freq[i][c] = get(freq[i], c, 0) + 1
        end
    end

    for f in freq
        sort(collect(f); by = last)[1] |> first |> print
    end
end
