using CombinedParsers

abstract type Instruction end

struct Cpy <: Instruction
    from::Union{Int, Char}
    to::Union{Int, Char}
end

struct Jnz <: Instruction
    test::Union{Int, Char}
    by::Union{Int, Char}
end

struct Inc <: Instruction
    reg::Char
end

struct Dec <: Instruction
    reg::Char
end

struct Tgl <: Instruction
    reg::Char
end

function readinput(file)
    numOrRegP = Either(Numeric(Int), CharIn('a':'d'))
    cpyP = Sequence("cpy ", numOrRegP, " ", numOrRegP) do t
        Cpy(t[2], t[4])
    end
    incP = Sequence("inc ", CharIn('a':'d')) do t
        Inc(t[2])
    end
    decP = Sequence("dec ", CharIn('a':'d')) do t
        Dec(t[2])
    end
    jnzP = Sequence("jnz ", numOrRegP, " ", numOrRegP) do t
        Jnz(t[2], t[4])
    end
    tglP = Sequence("tgl ", CharIn('a':'d')) do t
        Tgl(t[2])
    end
    instructionP = Either(cpyP, incP, decP, jnzP, tglP)
    data = []
    
    for line in eachline(file)
        push!(data, parse(instructionP, line))
    end
    data
end

const Program = Vector{Instruction}
const Registers = Dict{Char, Int}

mutable struct State
    pos::Int
    prog::Program
    reg::Registers
end

function execute!(state::State, instr::Cpy)
    if instr.to isa Char 
        val = if instr.from isa Int
            instr.from
        else
            state.reg[instr.from]
        end
        state.reg[instr.to] = val
    end
    state.pos += 1
end

function execute!(state::State, instr::Jnz)
    val = instr.test isa Int ? instr.test : state.reg[instr.test]
    by = instr.by isa Int ? instr.by : state.reg[instr.by]
    step = val == 0 ? 1 : by
    state.pos += step
end

function execute!(state::State, instr::Inc)
    state.reg[instr.reg] += 1
    state.pos += 1
end

function execute!(state::State, instr::Dec)
    state.reg[instr.reg] -= 1
    state.pos += 1
end

function execute!(state::State, instr::Tgl)
    n = state.reg[instr.reg] + state.pos
    if 1<= n <= length(state.prog)
        state.prog[n] = toggle(state.prog[n])
    end
    state.pos += 1    
end

toggle(instr::Inc) = Dec(instr.reg)

toggle(instr::Dec) = Inc(instr.reg)

toggle(instr::Tgl) = Inc(instr.reg)

toggle(instr::Jnz) = Cpy(instr.test, instr.by)

toggle(instr::Cpy) = Jnz(instr.from, instr.to)

function day23a()
    registers = Registers(['a' => 7, 'b' => 0, 'c' => 0, 'd' => 0])
    program = readinput("../inputs/23.input")
    state = State(1, program, registers)
    while state.pos <= length(program)
        execute!(state, state.prog[state.pos])
    end
    state.reg['a']
end

function day23b()
    registers = Registers(['a' => 12, 'b' => 0, 'c' => 0, 'd' => 0])
    program = readinput("../inputs/23.input")
    state = State(1, program, registers)
    while state.pos <= length(program)
        execute!(state, state.prog[state.pos])
    end
    state.reg['a']
end
