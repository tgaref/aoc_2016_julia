import Base.show

function show(io::IO, v::Vector{Bool})
    s = ""
    for c in v
        s = string(s, c ? '^' : '.')
    end
    print(io,s)
end

readinput(file) = [c == '.' ? false : true for c in read(file, String)]

function istrap(prevrow::Vector{Bool}, i::Int)
    l = i == 1 ? false : prevrow[i-1]
    c = prevrow[i]
    r = i == length(prevrow) ? false : prevrow[i+1]

    (l && c && (!r)) || ((!l) && c && r) || (l && (!c) & (!r)) || ((!l) && (!c) && r)    
end

function next(row::Vector{Bool})
    newrow = Bool[]
    for i in 1:length(row)
        t = istrap(row, i)
        push!(newrow, t)
    end
    newrow
end

function day18a()
    row = readinput("../inputs/18.input")
    cnt = count(b -> ! b, row)
    for _ in 1:39
        row = next(row)
        cnt += count(b -> ! b, row)
    end
    cnt
end

function day18b()
    row = readinput("../inputs/18.input")
    cnt = count(b -> ! b, row)
    for _ in 1:399999
        row = next(row)
        cnt += count(b -> ! b, row)
    end
    cnt
end
