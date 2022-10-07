using CombinedParsers, AutoHashEquals, DataStructures

struct Data
    x::Int
    y::Int
    used::Int
    avail::Int
end

struct State
    empty::Tuple{Int, Int}
    wanted::Tuple{Int, Int}
end

function readinput(file)
    sizeP = Sequence(Numeric(Int), "T")
    lineP = Sequence("/dev/grid/node-x", Numeric(Int), "-y", Numeric(Int), whitespace, sizeP, whitespace, sizeP, whitespace, sizeP, whitespace, Numeric(Int), "%") do t
        Data(t[2], t[4], t[8][1], t[10][1])
    end
    data = Data[]        
    for line in eachline(file)
        push!(data, parse(lineP, line))
    end
    data
end

function day22a()
    data = readinput("../inputs/22.input")
    cnt = 0
    for i in 1:length(data)
        for j in 1:length(data)
            i == j && continue
            if data[i].used > 0 && data[i].used <= data[j].avail
                cnt += 1
            end
        end
    end
    cnt
end

function adjacent(state::State, small::Set{Tuple{Int, Int}})
    (x,y) = state.empty
    filter([(x-1,y), (x+1,y), (x,y-1), (x,y+1)]) do (a,b)
       (a,b) in small
    end    
end

function neighbours(state::State, small::Set{Tuple{Int, Int}})
    nei = Set{State}()    
    for (x,y) in adjacent(state, small)
        wanted = state.wanted == (x,y) ? state.empty : state.wanted
        push!(nei, State((x,y), wanted))
    end
    nei
end

function update!(pq::PriorityQueue{K,V}, k::K, v::V) where {K} where {V}
    haskey(pq, k) && dequeue!(pq, k)
    enqueue!(pq, k => v)
end

function dijkstra(initial::State, small)
    temppq = PriorityQueue{State, Int}()
    tempdist = Dict{State, Int}()
    known = Set{State}()
    dist = Dict{State, Int}()
    enqueue!(temppq, initial => 0)
    tempdist[initial] = 0
    state = initial
    while state.wanted != (0,0)
        state = dequeue!(temppq)        
        d = tempdist[state]
        push!(known, state)
        dist[state] = d
        nei = setdiff(neighbours(state, small), known)
        for s in nei
            if ! haskey(tempdist, s)
                tempdist[s] = d+1
            else 
                tempdist[s] = min(d+1, tempdist[s])
            end
            update!(temppq, s, tempdist[s])
        end
    end
    dist[state]    
end
              
function initialize(file)
    data = readinput(file)    
    n = foldl((acc, node) -> max(acc, node.x), data; init = 0)
    small = Set{Tuple{Int, Int}}()
    e = (-1,-1)
    for node in data        
        if node.used == 0
            e = (node.x,node.y)
        elseif node.used <= 93
            push!(small, (node.x, node.y))
        end
    end
    (State(e, (n,1)), small)
end

function day22b()
    (init, small) = initialize("../inputs/22.input")
    dijkstra(init, small)
end    
