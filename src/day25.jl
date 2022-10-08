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

struct Out <: Instruction
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
    outP = Sequence("out ", CharIn('a':'d')) do t
        Out(t[2])
    end
    instructionP = Either(cpyP, incP, decP, jnzP, outP)
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

function execute!(state::State, instr::Out)
    print("$(state.reg[instr.reg]) ")
    state.pos += 1
end

# the program in 25.input is periodic.
# it repeats lines 9-end.
# the program outputs the binary digits
# of d in reverse order (least significant bit first)
# and repeats

function day25a()
    program = readinput("../inputs/25.input")

    registers = Registers(['a' => 4, 'b' => 0, 'c' => 0, 'd' => 0])
    state = State(1, program, registers)
    visited = 0
    while visited < 2
        execute!(state, state.prog[state.pos])
        if state.pos == 9
            visited += 1
            end
        if state.pos == 11
            println(state.reg)
        end
    end
end

function day25b()
end

function test()
    a = 2^7 + 2^5 - 2
    println(a)
    d = 643*4 + a
end
