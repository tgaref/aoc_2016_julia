using CombinedParsers

function decompress(::Val{:a}, markerP, str)
    j = findfirst('(', str)
    if j == nothing
        return length(str)
    elseif j > 1
        return j-1 + decompress(Val(:a), markerP, str[j:end])
    end
    # at this point j == 1, i.e., str begins with (
    k = findfirst(')', str)
    t = parse(markerP, str[1:k])
    no = t[:by] * t[:num]
    no + decompress(Val(:a), markerP, str[k+1+t[:num] : end])
end

function day9a()
    data = read("../inputs/9.input", String)
    # data = "X(8x2)(3x3)ABCY"
    markerP = Sequence("(", :num => Numeric(Int), "x", :by => Numeric(Int), ")")
    decompress(Val(:a), markerP, data)
end

function decompress(::Val{:b}, markerP, str)
    j = findfirst('(', str)
    if j == nothing
        return length(str)
    elseif j > 1
        return j-1 + decompress(Val(:b), markerP, str[j:end])
    end
    # at this point j == 1, i.e., str begins with (
    k = findfirst(')', str)
    t = parse(markerP, str[1:k])
    no = t[:by] * decompress(Val(:b), markerP, str[k+1:k+t[:num]])
    no + decompress(Val(:b), markerP, str[k+1+t[:num] : end])
end

function day9b()
    data = read("../inputs/9.input", String)
    #data = "(27x12)(20x12)(13x14)(7x10)(1x12)A"
    markerP = Sequence("(", :num => Numeric(Int), "x", :by => Numeric(Int), ")")
    decompress(Val(:b), markerP, data)
end
