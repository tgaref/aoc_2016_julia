using CombinedParsers
import CombinedParsers: word

function readinput(file)
    room = Sequence(:name => join(Repeat(word), "-"),
                    "-",
                    :id => Numeric(Int),
                    "[",
                    :checksum => word,
                    "]")
    data = NamedTuple{(:name, :id, :checksum), Tuple{Vector{String}, Int, String}}[]
    for line in eachline(file)
        push!(data, parse(room, line))
    end
    data
end

function isvalid(room)
    freq = Dict{Char, Int}()
    for c in join(room[:name])
        freq[c] = get(freq, c, 0) + 1
    end
    invfreq = Dict{Int, Vector{Char}}()
    for (c, n) in freq
        invfreq[n] = push!(get(invfreq, n, []), c)
    end
    s = ""
    for (n, v) in sort(collect(invfreq); by = first, rev = true)
        s *= join(sort(v))
    end
    s[1:5] == room[:checksum] ? true : false
end

function day4a()
    rooms = readinput("../inputs/4.input")
    sum(isvalid(room) ? room[:id] : 0 for room in rooms)
end

function shift(word, n)
    letters = 'a':'z'
    start = 97 # Int('a')
    map(c -> letter[((Int(c)-start)+n) % 26 + 1], word)        
end

function decrypt(room)
    join((shift(w, room[:id]) for w in room[:name]), " ")        
end

function day4b()
    rooms = readinput("../inputs/4.input")
    for room in filter(isvalid, rooms)
        if contains(decrypt(room), "north")
            println(room[:id])
        end
    end    
end
