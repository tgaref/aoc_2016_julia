using CombinedParsers

abstract type Instruction end

struct CpyVal <: Instruction
    val::Int
    to::Char
end

struct CpyReg <: Instruction
    from::Char
    to::Char
end

struct Inc <: Instruction
    reg::Char
end

struct Dec <: Instruction
    reg::Char
end

struct JnzVal <: Instruction
    val::Int
    n::Int
end

struct JnzReg <: Instruction
    reg::Char
    n::Int
end

function readinput(file)
    cpyValP = Sequence("cpy ", Numeric(Int), " ", CharIn('a':'d')) do t
        CpyVal(t[2], t[4])
    end
    cpyRegP = Sequence("cpy ", CharIn('a':'d'), " ", CharIn('a':'d')) do t
        CpyReg(t[2], t[4])
    end
    incP = Sequence("inc ", CharIn('a':'d')) do t
        Inc(t[2])
    end
    decP = Sequence("dec ", CharIn('a':'d')) do t
        Dec(t[2])
    end
    JnzValP = Sequence("jnz ", Numeric(Int), " ", Numeric(Int)) do t
        JnzVal(t[2], t[4])
    end
    JnzRegP = Sequence("jnz ", CharIn('a':'d'), " ", Numeric(Int)) do t
        JnzReg(t[2], t[4])
    end
    instructionP = Either(cpyValP, cpyRegP, incP, decP, JnzValP, JnzRegP)
    data = []
    
    for line in eachline(file)
        push!(data, parse(instructionP, line))
    end
    data
end

const State = Dict{Char, Int}

function execute!(state::State, instr::CpyVal)
    state[instr.to] = instr.val
    1
end

function execute!(state::State, instr::CpyReg)
    state[instr.to] = state[instr.from]
    1
end

function execute!(state::State, instr::Inc)
    state[instr.reg] += 1
    1
end

function execute!(state::State, instr::Dec)
    state[instr.reg] -= 1
    1
end

function execute!(state::State, instr::JnzVal)
    instr.val == 0 ? 1 : instr.n
end

function execute!(state::State, instr::JnzReg)
    state[instr.reg] == 0 ? 1 : instr.n
end

function day12a()
    state = State(['a' => 0, 'b' => 0, 'c' => 0, 'd' => 0])
    program = readinput("../inputs/12.input")
    i = 1
    while i <= length(program)
        i += execute!(state, program[i])
    end
    state['a']
end

function day12b()
    state = State(['a' => 0, 'b' => 0, 'c' => 1, 'd' => 0])
    program = readinput("../inputs/12.input")
    i = 1
    while i <= length(program)
        i += execute!(state, program[i])
    end
    state['a']
end
