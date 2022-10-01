using AutoHashEquals, DataStructures
using Combinatorics: combinations
import Base.show

@auto_hash_equals struct State
    pos::Integer
    floor::Vector{Tuple{Int, Int}}
end

function Base.show(io::IO, state::State)
    println()
    for i in 4:-1:1
        print("$i -> ")
        i == state.pos ? print("*  ") : print("   ")
        print(state.floor[i][1])
        print(" | ")
        print(state.floor[i][2])
        println()
    end
end

function adjfloors(f::Int)
    if f == 1
        [2]
    elseif f == 4
        [3]
    else
        [f-1, f+1]
    end        
end

function update!(pq::PriorityQueue{K,V}, k::K, v::V) where {K} where {V}
    haskey(pq, k) && dequeue!(pq, k)
    enqueue!(pq, k => v)
end

function dijkstra(initial, goal)
    temppq = PriorityQueue{State, Int}()
    tempdist = Dict{State, Int}()
    known = Set{State}()
    dist = Dict{State, Int}()
    enqueue!(temppq, initial => 0)
    tempdist[initial] = 0
    state = initial
    while state != goal
        state = dequeue!(temppq)
        d = tempdist[state]
        push!(known, state)
        dist[state] = d
        nei = setdiff(neighbours(state), known)
        for s in collect(nei)
            if ! haskey(tempdist, s)
                tempdist[s] = d+1
            else 
                tempdist[s] = min(d+1, tempdist[s])
            end
            update!(temppq, s, tempdist[s])
        end
    end
    dist
end

function neighbours(state::State)
    nei = Set{State}()
    for f in adjfloors(state.pos)
        chips = state.floor[state.pos][1]
        gens = state.floor[state.pos][2]
        for i in 0:min(2,chips), j in 0:min(2,gens)
            if 1 <= i+j <= 2
                newfloor = copy(state.floor)
                (a,b) = state.floor[state.pos]
                newfloor[state.pos] = (a-i, b-j)
                (a,b) = state.floor[f]
                newfloor[f] = (a+i, b+j)
                newstate = State(f, newfloor)
                isvalid(newstate) && push!(nei, newstate)
            end
        end
    end
    nei
end

isvalid(state::State) = all(t -> t[2] == 0 || t[1] <= t[2], state.floor)

function day11a()
    initial = State(1, [(2,2), (2,3), (1,0), (0,0)])
    goal = State(4, [(0,0), (0,0), (0,0), (5,5)])
    dijkstra(initial, goal)[goal]
end

function day11b()
    initial = State(1, [(4,4), (2,3), (1,0), (0,0)])
    goal = State(4, [(0,0), (0,0), (0,0), (7,7)])                     
    dijkstra(initial,goal)[goal]    
end
