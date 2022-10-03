using MD5

function hastriple(s)
    for i in 1:length(s)-2
        if s[i] == s[i+1] == s[i+2]
            return s[i]
        end        
    end
    nothing
end


function hash(s, n)
    h = s
    for _ in 1:n
        h = md5(h) |> bytes2hex
    end
    h
end

function goodhash(salt, k, n)
    c = nothing
    while isnothing(c)
        h = hash(salt * string(k), n)
        c = hastriple(h)
        k += 1 
    end
    (k-1, c)
end

function repeat5times(s)
    res = Set{Char}()
    for i in 1:length(s)-4
        if s[i] == s[i+1] == s[i+2] == s[i+3] == s[i+4]
            push!(res, s[i])
        end
    end
    res
end

function day14a()
    salt = "ngcjuoqr"
    # salt = "abc"
    promissing = Dict{Char, Int}()
    cnt = 0
    k = -1
    promhashindex = 0
    while cnt < 64
        (k,c) = goodhash(salt, k+1, 1)
        found = false
        if haskey(promissing, c) && k+1 <= promissing[c] <= k+1000
            cnt += 1
            found = true
        end
        i = max(k+1, promhashindex)
        while i <= k+1000 && ! found
            h = hash(salt * string(i), 1)
            set = repeat5times(h)
            for a in set
                promissing[a] = i
            end
            if c in set
                found = true
                cnt += 1
            end
            i += 1
        end
        promhashindex = i - 1
    end
    k
end

function day14b()
    salt = "ngcjuoqr"
    # salt = "abc"
    promissing = Dict{Char, Int}()
    cnt = 0
    k = -1
    promhashindex = 0
    while cnt < 64
        (k,c) = goodhash(salt, k+1, 2017)
        found = false
        if haskey(promissing, c) && k+1 <= promissing[c] <= k+1000
            cnt += 1
            found = true
        end
        i = max(k+1, promhashindex)
        while i <= k+1000 && ! found
            h = hash(salt * string(i), 2017)
            set = repeat5times(h)
            for a in set
                promissing[a] = i
            end
            if c in set
                found = true
                cnt += 1
            end
            i += 1
        end
        promhashindex = i - 1
    end
    k
end
