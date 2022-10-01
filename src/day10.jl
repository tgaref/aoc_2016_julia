using CombinedParsers

abstract type Instruction end

struct Bot
    no::Int
end

struct Output
    no::Int
end

struct Input <: Instruction
    bot::Bot
    value::Int
end

struct Give <: Instruction
    bot::Bot
    low::Union{Bot, Output}
    high::Union{Bot, Output}
end

struct State
    bot::Dict{Int, Vector{Int}}
    output::Dict{Int, Vector{Int}}
end

function readinput(file)
    inputP = Sequence("value ", Numeric(Int), " goes to bot ", Numeric(Int)) do t
        Input(Bot(t[4]), t[2])
    end
    giveP = Sequence("bot ", Numeric(Int), " gives low to ", ("bot " | "output "),
                     Numeric(Int), " and high to ", ("bot " | "output "), Numeric(Int)) do t
                         bot = Bot(t[2])
                         low = t[4] == "bot " ? Bot(t[5]) : Output(t[5])
                         high = t[7] == "bot " ? Bot(t[8]) : Output(t[8])
                         Give(bot, low, high)
    end
    data = Instruction[]
    for line in eachline(file)
        push!(data, parse(Either(inputP, giveP), line))
    end
    data                     
end

function execute!(state::State, action::Input, rules::Dict{Int, Instruction})
    state.bot[action.bot.no] = push!(get(state.bot, action.bot.no, []), action.value)
    execute!(state, rules[action.bot.no], rules)
end

function execute!(state::State, action::Give, rules::Dict{Int, Instruction})
    bot = action.bot
    if length(get(state.bot, bot.no, 0)) < 2
        return nothing
    end
    low = action.low
    high = action.high
    (m,M) = minmax(state.bot[bot.no]...)
    if (m,M) == (17,61)
        println("$bot compares values 17 and 61")
    end
    if low isa Bot
        state.bot[low.no] = push!(get(state.bot, low.no, []), m)
    else
        state.output[low.no] = push!(get(state.output, low.no, []), m)
    end
    if high isa Bot
        state.bot[high.no] = push!(get(state.bot, high.no, []), M)
    else
        state.output[high.no] = push!(get(state.output, high.no, []), M)      
    end    
    state.bot[bot.no] = state.bot[bot.no][3:end]
    low isa Bot ? execute!(state, rules[low.no], rules) : nothing
    high isa Bot ? execute!(state, rules[high.no], rules) : nothing
end

function day10()
    instructions = readinput("../inputs/10.input")
    rules = Dict{Int, Instruction}()
    bots = Dict{Int, Vector{Int}}()
    outputs = Dict{Int, Vector{Int}}()
    state = State(bots, outputs)
    for action in instructions
        if action isa Give
            rules[action.bot.no] = action
        end
    end
    for action in instructions
        execute!(state, action, rules)
    end
    state.output[0][1] * state.output[1][1] * state.output[2][1]
end
