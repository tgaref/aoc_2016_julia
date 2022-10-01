using CombinedParsers
import CombinedParsers: word

function readinput(file)
    bracket = Sequence("[", word, "]")
    ip = Repeat(Sequence(word, bracket[2])) * word
    input = []
    for line in eachline(file)
        push!(input, parse(ip, line))
    end
    data = NTuple{2,Vector{String}}[]
    for t in input
        (positive, negative) = unzip(t[1])
        length(t) == 2 && push!(positive, t[2])
        push!(data, (positive, negative))
    end
    data
end

function unzip(v::Vector{Tuple{S,T}}) where {S} where {T}
    va = S[]
    vb = T[]
    for (a,b) in v
        push!(va, a)
        push!(vb, b)
    end
    (va, vb)
end

function hasABBA(s::String)
    for i in 4:length(s)
        s[i-3] == s[i] && s[i-2] == s[i-1] && s[i] != s[i-1] && return true
    end
    false
end

function supportTLS(va, vb)
    any(hasABBA, va) && ! any(hasABBA, vb)
end

function createABA(s::String)
    aba = Set{String}()
    for i in 1:length(s)-2
        if s[i] == s[i+2] && s[i] != s[i+1]
            push!(aba, s[i:i+2])
        end
    end
    aba
end

function createBAB(s::String)
    aba = Set{String}()
    for i in 1:length(s)-2
        if s[i] == s[i+2] && s[i] != s[i+1]
            push!(aba, join((s[i+1], s[i], s[i+1])))
        end
    end
    aba
end

function supportSSL(va, vb)
    aba = Set{String}()
    for s in va
       union!(aba, createABA(s)) 
    end
    bab = Set{String}()
    for s in vb
        union!(bab, createBAB(s))
    end
    length(intersect(aba, bab)) > 0
        
end

function day7a()
    data = readinput("../inputs/7.input")
    count(t -> supportTLS(t...), data)
end

function day7b()
    data = readinput("../inputs/7.input")
    count(t -> supportSSL(t...), data)
end
