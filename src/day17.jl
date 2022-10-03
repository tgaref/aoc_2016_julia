using MD5

struct State
    pos::Tuple{Int, Int}
    path::String
end

function nextdirections(state::State, pass::String, unlocked::Set{Char})
    h = md5(pass * state.path)[1:4] |> bytes2hex
    (x,y) = state.pos
    possibilities = Set{Char}()
    if in(h[1], unlocked) && y > 1
        push!(possibilities, 'U')
    end
    if in(h[2], unlocked) && y < 4
       push!(possibilities, 'D')
    end
    if in(h[3], unlocked) && x > 1 
       push!(possibilities, 'L')
    end 
    if in(h[4], unlocked) && x < 4 
       push!(possibilities, 'R')
    end 
    possibilities
end

function neighbourInDir(state::State, dir::Char)
    (x,y) = state.pos
    (x1,y1) = if dir == 'U'
        (x, y-1)
    elseif dir == 'D'
        (x, y+1)
    elseif dir == 'L'
        (x-1, y)
    else
        (x+1, y)
    end
    State((x1,y1), string(state.path, dir))
end

function neighbours(state::State, pass::String, unlocked::Set{Char})
    nei = Set{State}()
    for dir in nextdirections(state, pass, unlocked)
        push!(nei, neighbourInDir(state, dir))
    end
    nei
end

function bfs(::Val{:a}, initial::State, pass)
    unlocked = Set('b':'f')
    queue = [initial]
    state = queue[1]
    while state.pos != (4,4)
        for s in neighbours(state, pass, unlocked) 
            push!(queue, s)
        end
        queue = queue[2:end]
        state = queue[1]
    end
    state.path
end

function bfs(::Val{:b}, initial::State, pass)
    unlocked = Set('b':'f')
    queue = [initial]
    m = 0
    while length(queue) > 0
        state = queue[1]
        if state.pos == (4,4)
            m = max(m, length(state.path))
        else
            for s in neighbours(state, pass, unlocked) 
                push!(queue, s)
            end
        end
        queue = queue[2:end]
    end
    m
end

function day17a()
    pass = "pvhmgsws"
    initial = State((1,1), "")
    bfs(Val(:a), initial, pass)
end

function day17b()
    pass = "pvhmgsws"
    initial = State((1,1), "")
    goal(s) = s.pos == (4,4)
    bfs(Val(:b), initial, pass)
end
