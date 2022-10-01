using CombinedParsers

abstract type Instruction end

struct Rect <: Instruction
    A::Int
    B::Int    
end

struct RotateRow <: Instruction
    y::Int
    by::Int
end

struct RotateCol <: Instruction
    x::Int
    by::Int
end

function readinput(file)
    rectP = Sequence("rect ", Numeric(Int), "x", Numeric(Int)) do t
        Rect(t[2], t[4])
    end    
    rotateRowP = Sequence("rotate row y=", Numeric(Int), " by ", Numeric(Int)) do t
        RotateRow(t[2], t[4])
    end
    rotateColP = Sequence("rotate column x=", Numeric(Int), " by ", Numeric(Int)) do t
        RotateCol(t[2], t[4])
    end
    instructionP = (rectP | rotateRowP | rotateColP)    
    input = Instruction[]
    for line in eachline(file)
        push!(input, parse(instructionP, line))
    end
    input       
end

function rect!(grid, A, B)
    for x in 1:B, y in 1:A
        grid[x,y] = '#'
    end
    grid
end

function rotaterow!(grid, y, n)
    grid[y+1,:] = circshift(grid[y+1,:], n)
    grid           
end

function rotatecol!(grid, x, n)
    grid[:,x+1] = circshift(grid[:,x+1], n)
    grid
end

execute!(grid, instr::Rect) = rect!(grid, instr.A, instr.B)

execute!(grid, instr::RotateRow) = rotaterow!(grid, instr.y, instr.by)

execute!(grid, instr::RotateCol) = rotatecol!(grid, instr.x, instr.by)

function day8a()
    data = readinput("../inputs/8.input")
    grid = fill(' ', (6,50))
    for instr in data
        execute!(grid, instr)
    end
    count(x -> x == '*', grid)
end

function deije(m)
    s = ""
    for i in 1:size(m,1)
        s = s * join(m[i,:]) * "\n"
    end
    s
end

function day8b()
    data = readinput("../inputs/8.input")
    grid = fill(' ', (6,50))
    for instr in data
        execute!(grid, instr)
    end

    for i in 1:5:50
        deije(@view grid[:,i:i+4]) |> println
    end
end

