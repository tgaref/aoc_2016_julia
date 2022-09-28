using CombinedParsers

function readinput(filename)
    data = read(filename, String)
    dir = Sequence(Optional(whitespace),
                   :direction => ("R" | "L"),
                   :steps => Numeric(Int))
    dirs = join(Repeat(dir), ",")
    parse(dirs , data)
end

function rotate(dir, angle)
    if angle == "L"
        [0 -1; 1 0] * dir
    else
        [0 1; -1 0] * dir
    end
end

function day1a()
    data = readinput("../inputs/1.input")
    pos = [0,0]
    dir = [0,1]
    for item in data
        dir = rotate(dir, item[:direction])
        pos = pos + item[:steps] * dir
    end
    abs(pos[1]) + abs(pos[2])
end

function day1b()
    data = readinput("../inputs/1.input")
    pos = [0,0]
    dir = [0,1]
    visited = Set{Tuple{Int, Int}}([(0,0)])
    for item in data
        dir = rotate(dir, item[:direction])
        newpos = pos + item[:steps] * dir
        t = Tuple(pos)
        for i in 1:item[:steps]
            pos = pos + dir
            t = Tuple(pos)
            if t in visited
                return abs(t[1]) + abs(t[2])                
            else
                push!(visited, t)
            end
        end
    end
end
