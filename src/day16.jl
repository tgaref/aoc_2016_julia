
function step(s)
    t = copy(s) |> reverse
    vcat(push!(s,false), map(x -> !x, t))    
end

function gendata(init, n)
    s = copy(init)
    while length(s) < n
        s = step(s)
    end
    s[1:n]
end

function checksum(s)
    cs = Bool[]
    for i in 1:2:length(s)-1
        push!(cs, s[i] == s[i+1] ? true : false)
    end
    cs
end

function string2boolarray(s)
    map(x -> x == '0' ? false : true, collect(s))
end

function day16a()
    init = string2boolarray("10001110011110000")
    disksize = 272
    data = gendata(init, disksize)
    cs = checksum(data)
    while iseven(length(cs))
        cs = checksum(cs)
    end
    map(x -> string(Int(x)), cs) |> join
end

function day16b()
    init = string2boolarray("10001110011110000")
    disksize = 35651584
    data = gendata(init, disksize)
    cs = checksum(data)
    while iseven(length(cs))
        cs = checksum(cs)
    end
    map(x -> string(Int(x)), cs) |> join
end

             
