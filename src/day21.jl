using CombinedParsers

abstract type Instruction end

struct SwapPos <: Instruction
    a::Int
    b::Int
end

struct SwapLetter <: Instruction
    a::Char
    b::Char
end

struct RotateL <: Instruction
    by::Int
end

struct RotateR <: Instruction
    by::Int
end

struct RotatePos <: Instruction
    pos::Char
end

struct Reverse <: Instruction
    from::Int
    to::Int
end

struct Move <: Instruction
    from::Int
    to::Int
end

function readinput(file)
    swapPosP = Sequence("swap position ", Numeric(Int), " with position ", Numeric(Int)) do t
        SwapPos(t[2],t[4])
    end
    swapLetterP = Sequence("swap letter ", CharIn('a':'z'), " with letter ", CharIn('a':'z')) do t
        SwapLetter(t[2],t[4])
    end

    rotateLP = Sequence("rotate left ", Numeric(Int), (" steps" | " step")) do t
        RotateL(t[2])
    end

    rotateRP = Sequence("rotate right ", Numeric(Int), (" steps" | " step")) do t
        RotateR(t[2])
    end
    
    rotatePosP = Sequence("rotate based on position of letter ", CharIn('a':'z')) do t
        RotatePos(t[2])
    end

    reverseP = Sequence("reverse positions ", Numeric(Int), " through ", Numeric(Int)) do t
        Reverse(t[2], t[4])
    end
    
    moveP = Sequence("move position ", Numeric(Int), " to position ", Numeric(Int)) do t
        Move(t[2], t[4])
    end

    instructionP = Either(swapPosP, swapLetterP, rotateLP, rotateRP, rotatePosP, reverseP, moveP)

    instructions = Instruction[]
    for line in eachline(file)
        push!(instructions, parse(instructionP, line))
    end
    instructions
end

function swapPos!(s::Vector{Char}, i::Int, j::Int)
    t = s[i]
    s[i] = s[j]
    s[j] = t
    s
end

function swapLetter!(s::Vector{Char}, a::Char, b::Char)
    i = findfirst(x -> x == a, s)
    j = findfirst(x -> x == b, s)
    swapPos!(s, i, j)
end

function rotatePos!(s::Vector{Char}, pos::Char)
    n = findfirst(x -> x == pos, s)
    n = n >= 5 ? n+1 : n
    circshift(s, n)
end

function reverserange!(s::Vector{Char}, i::Int, j::Int)
    reverse!(@view s[i:j])
    s
end

function move!(s::Vector{Char}, i::Int, j::Int)
    t = s[i]    
    if i < j        
        for k in i+1:j
            s[k-1] = s[k]
        end
    else
        for k in i-1:-1:j
            s[k+1] = s[k]
        end
    end
    s[j] = t
    s
end

function execute!(instruction::Instruction, s::Vector{Char})
    if instruction isa SwapPos
        swapPos!(s, instruction.a+1, instruction.b+1)
    elseif instruction isa SwapLetter
        swapLetter!(s, instruction.a, instruction.b)
    elseif instruction isa RotateL
        circshift(s, -instruction.by)
    elseif instruction isa RotateR
        circshift(s, instruction.by)
    elseif instruction isa RotatePos
        rotatePos!(s, instruction.pos)
    elseif instruction isa Reverse
        reverserange!(s, instruction.from+1, instruction.to+1)
    elseif instruction isa Move
        move!(s, instruction.from+1, instruction.to+1)
    end
end

function undo!(instruction::Instruction, s::Vector{Char})
    if instruction isa SwapPos
        swapPos!(s, instruction.a+1, instruction.b+1)
    elseif instruction isa SwapLetter
        swapLetter!(s, instruction.a, instruction.b)
    elseif instruction isa RotateL
        circshift(s, instruction.by)
    elseif instruction isa RotateR
        circshift(s, -instruction.by)
    elseif instruction isa RotatePos
        i = findfirst(x -> x == instruction.pos, s)-1
        orig_pos = if i == 0
            7
        elseif i == 1
            0
        elseif i == 2
            4
        elseif i == 3
            1
        elseif i == 4
            5
        elseif i == 5
            2
        elseif i == 6
            6
        elseif i == 7
            3
        end
        circshift(s, orig_pos - i)
    elseif instruction isa Reverse
        reverserange!(s, instruction.from+1, instruction.to+1)
    elseif instruction isa Move
        move!(s, instruction.to+1, instruction.from+1)
    end
end

function day21a()
    instructions = readinput("../inputs/21.input")
    password = collect("abcdefgh")
    for instruction in instructions
        password = execute!(instruction, password)
    end
    String(password)
end

function day21b()
    instructions = readinput("../inputs/21.input")
    password = collect("fbgdceah")
    for (i,instruction) in enumerate(reverse(instructions))
        password = undo!(instruction, password)
    end
    String(password)
end

