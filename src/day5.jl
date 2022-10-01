using MD5

function day5a()
    id = "ffykfhsq"    
    n = 0
    ds = Char[]
    i = 0
    while n < 8
        h = bytes2hex(md5(id * string(i)))[1:6]
        if h[1:5] == "00000"
            push!(ds, h[6])
            n += 1
        end
        i += 1
    end 
    join(ds)
end

function day5b()
    id = "ffykfhsq"
    n = 0
    ds = repeat(['-'],8)
    i = 0
    legal = Set{Char}('0':'7')
    while n < 8
        h = bytes2hex(md5(id * string(i)))[1:7]
        if h[1:5] == "00000" && h[6] in legal
            p = parse(Int, h[6]) + 1
            if ds[p] == '-'
                ds[p] = h[7]                
                n += 1
            end
        end
        i += 1
    end 
    join(ds)
end
