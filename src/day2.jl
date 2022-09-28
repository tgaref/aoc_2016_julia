using CombinedParsers

function readinput(filename)
    data = Vector{String}()
    for line in eachline(filename)
        push!(data, line)
    end
    data
end

function adjust(X,a,b)
    if X < a
        a
    elseif X > b
        b
    else
        X
    end
end

function move(d, pos::Tuple{Int, Int}, dir::Char)
    (x,y) = pos
    (X,Y) = if dir == 'U'
        (x,y-1)
    elseif dir == 'D'
        (x,y+1)
    elseif dir == 'L'
        (x-1,y)
    else
        (x+1,y)
    end
    if d == :a
        (adjust(X,0,2), adjust(Y,0,2))
    else
        if abs(X) + abs(Y) > 2
            (x,y)
        else
            (X,Y)
        end
    end
end

function move(d, pos::Tuple{Int, Int}, dirs::String)
    for dir in dirs
        pos = move(d, pos, dir)
    end
    pos
end

function day2a()
    data = readinput("../inputs/2.input")
    positions = Dict{Tuple{Int, Int}, Char}([(0,0) => '1',
                                             (1,0) => '2',
                                             (2,0) => '3',
                                             (0,1) => '4',
                                             (1,1) => '5',
                                             (2,1) => '6',
                                             (0,2) => '7',
                                             (1,2) => '8',
                                             (2,2) => '9'])
                                             
    code = Vector{Char}()
    pos = (1,1)
    for (i, line) in enumerate(data)
        for dir in line
            pos = move(:a, pos, dir)
        end
        push!(code, positions[pos])
    end
    String(code)
end

function day2b()
    data = readinput("../inputs/2.input")
    positions = Dict{Tuple{Int, Int}, Char}([(0,0) => '7',
                                             (1,0) => '8',
                                             (2,0) => '9',
                                             (-1,0) => '6',
                                             (-2,0) => '5',
                                             (0,-1) => '3',
                                             (1,-1) => '4',
                                             (-1,-1) => '2',
                                             (0,-2) => '1',
                                             (0,1) => 'B',
                                             (1,1) => 'C',
                                             (-1,1) => 'A',
                                             (0,2) => 'D'])
                                             
    code = Vector{Char}()
    pos = (-2,0)
    for (i, line) in enumerate(data)
        for dir in line
            pos = move(:b, pos, dir)
        end
        push!(code, positions[pos])
    end
    String(code)

end
