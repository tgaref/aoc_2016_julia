using DataStructures, Combinatorics

const Node = Tuple{Int, Int}

const Graph = Dict{Node, Set{Node}}

function readinput(file)
    data = String[]
    graph = Dict{Node, Set{Node}}()
    nodes = Set{Node}()
    targets = Set{Node}()
    source = (1,1)
    for line in eachline(file)
        push!(data, line)
    end
    for (i,line) in enumerate(data[2:end-1])
        for (j,c) in enumerate(line[2:end-1])
            if c == '.'
                push!(nodes, (i,j))
            elseif c == '0'
                push!(nodes, (i,j))
                source = (i,j)
            elseif c in ['1','2','3','4','5','6','7']
                push!(nodes, (i,j))
                push!(targets, (i,j))
            end
        end
    end
    (getgraph(nodes), source, targets)                     
end

function getgraph(nodes::Set{Node})
    graph = Graph()
    for (x,y) in nodes
        graph[(x,y)] = intersect(nodes, Set([(x-1,y), (x+1,y), (x,y-1), (x,y+1)]))
    end
    graph
end

function update!(pq::PriorityQueue{K,V}, k::K, v::V) where {K} where {V}
    haskey(pq, k) && dequeue!(pq, k)
    enqueue!(pq, k => v)
end

function dijkstra(graph::Graph, initial::Node)
    temppq = PriorityQueue{Node, Int}()
    tempdist = Dict{Node, Int}()
    known = Set{Node}()
    dist = Dict{Node, Int}()
    enqueue!(temppq, initial => 0)
    tempdist[initial] = 0
    while ! isempty(temppq)
        node = dequeue!(temppq)
        d = tempdist[node]
        push!(known, node)
        dist[node] = d
        nei = setdiff(graph[node], known)
        for s in nei
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

function day24a()
    (graph, source, targets) = readinput("../inputs/24.input")
    dist = Dict{Tuple{Node, Node}, Int}()
    
    d = dijkstra(graph, source)
    for t in targets
        dist[(source,t)] = d[t]
    end

    for s in targets
        d = dijkstra(graph, s)
        for t in targets
            dist[(s,t)] = d[t]
        end
    end

    m = 99999999999999
    path = []
    for p in permutations(collect(targets))
        cost = dist[(source, p[1])]
        for i in 2:length(p)
            cost += dist[(p[i], p[i-1])]
        end
        if cost < m
            m = cost
            path = p
        end
        
    end
    m
end

function day24b()
    (graph, source, targets) = readinput("../inputs/24.input")
    dist = Dict{Tuple{Node, Node}, Int}()
    
    d = dijkstra(graph, source)
    for t in targets
        dist[(source,t)] = d[t]
    end

    for s in targets
        d = dijkstra(graph, s)
        for t in targets
            dist[(s,t)] = d[t]
        end
    end

    m = 99999999999999
    path = []
    for p in permutations(collect(targets))
        cost = dist[(source, p[1])]
        for i in 2:length(p)
            cost += dist[(p[i], p[i-1])]
        end
        cost += dist[source, p[end]]
        if cost < m
            m = cost
            path = p
        end        
    end
    m
end
