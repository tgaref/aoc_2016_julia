using DataStructures

function day19a()
    n = 3001330
    bs = digits(n; base = 2)
    k = 1
    e = 2
    for b in bs[1:end-1]
        if b == 1
            k += e
        end
        e *= 2
    end
    k    
end

function step(left, right)
    
end

function day19b()
    n = 3001330
    left = Deque{Int}()
    right = Deque{Int}()
    for i in 1:div(n,2)
        push!(left, i)
    end
    for i in div(n,2)+1:n
        push!(right, i)
    end

    while ! isempty(right)
        if length(left) > length(right)
            pop!(left) # remove elf across the circle
        else
            popfirst!(right) # last element of left of first of right
        end
        a = popfirst!(left) # remove elf that just played
        push!(right, a) # add elf that just played to the end
        b = popfirst!(right) # the last two lines balance the two queues
        push!(left, b)
    end
    pop!(left)    
end
