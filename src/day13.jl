using DataStructures

const Node = Tuple{Int, Int}

function isopen(x,y)
    m = 1350 + (x+y)^2 + 3*x + y
    cnt = 0
    while m > 0
        (m,b) = divrem(m,2)
        cnt += b
    end
    iseven(cnt)
end

function neighbours(node)
    nei = Set{Tuple{Int, Int}}()
    for (i,j) in [(-1,0), (1,0), (0,-1), (0,1)]
        if i == 0 && j == 0
            continue
        end
        x1 = node[1] + i
        y1 = node[2] + j
        if x1 >= 0 && y1 >= 0 && isopen(x1,y1)
            push!(nei, (x1,y1))
        end
    end
    nei
end

function update!(pq::PriorityQueue{K,V}, k::K, v::V) where {K} where {V}
    haskey(pq, k) && dequeue!(pq, k)
    enqueue!(pq, k => v)
end

function dijkstra(initial::Node, goal::Node, finish, early)
    temppq = PriorityQueue{Node, Int}()
    tempdist = Dict{Node, Int}()
    known = Set{Node}()
    dist = Dict{Node, Int}()
    enqueue!(temppq, initial => 0)
    tempdist[initial] = 0
    state = initial
    while ! finish(state)
        state = dequeue!(temppq)
        d = tempdist[state]

        early(d) && return dist

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

function day13a()
    initial = (1,1)
    goal = (31,39)
    finish(s) = s == goal
    early(d) = false
    dijkstra(initial, goal, finish, early)[goal]
end

function day13b()
    initial = (1,1)
    goal = (31,39)
    finish(s) = false
    early(d) = d > 50
    length(keys(dijkstra(initial, goal, finish, early)))
end

