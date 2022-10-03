
struct Disc
    id::Int
    size::Int
    init::Int
end

function crt(as::Vector{T}, ns::Vector{T}) where T<:Integer
    N = prod(ns)
    res = T(0)
    for (a,n) in zip(as,ns)
        m = div(N,n)
        s = invmod(m,n)
        res = mod(res + a*m*s, N)
    end
    res
end

function day15a()
    discs = [Disc(1, 13, 1), Disc(2, 19, 10),
             Disc(3, 3, 2), Disc(4, 7, 1),
             Disc(5, 5, 3), Disc(6, 17, 5)]

    as = [mod(-d.init-d.id, d.size) for d in discs]
    ns = [d.size for d in discs]
    crt(as, ns)
end

function day15b()
    discs = [Disc(1, 13, 1), Disc(2, 19, 10),
             Disc(3, 3, 2), Disc(4, 7, 1),
             Disc(5, 5, 3), Disc(6, 17, 5),
             Disc(7, 11, 0)]

    as = [mod(-d.init-d.id, d.size) for d in discs]
    ns = [d.size for d in discs]
    crt(as, ns)
end
