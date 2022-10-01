using CombinedParsers

function readinput(filename)
    #data = Vector{NTuple{3, Int}}()
    data = []
    #triangle = trim(Numeric(Int)) * trim(Numeric(Int)) * trim(Numeric(Int))
    triangle = Sequence(whitespace, join(Repeat(Numeric(Int)), whitespace))
    for line in eachline(filename)
        push!(data, parse(triangle[2], line))        
    end
    data
end

function day3a()
    data = readinput("../inputs/3.input")
    for t in data
        sort!(t)
    end
    count(t -> t[1] + t[2] > t[3], data)    
end

function day3b()
    data = readinput("../inputs/3.input")
    mat = hcat(data...) |> transpose

    c = 0
    for j in 1:size(mat)[2]
        for i in 1:3:size(mat)[1]
            window = @view mat[i:i+2,j]
            t = sort(window)
            if t[1] + t[2] > t[3]
                c += 1
            end
        end
    end
    c
end
