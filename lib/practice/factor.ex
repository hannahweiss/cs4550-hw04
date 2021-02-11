defmodule Practice.Factor do

    def parse_int(text) do
        case is_integer(text) do
            true -> text
            false -> 
                {num, _} = Integer.parse(text)
                num
        end
        
      end

    def is_prime?(num, z) do
        if num == 1 do 
            false
        else
            if num == z do
                true
            else
                if rem(num, z) == 0 do
                    false
                else
                    is_prime?(num, z + 1)
                end
            end
        end
        

    end

    def find_factors(num, i, list_of_factors) do
        if is_prime?(num, 2) do
            list_of_factors ++ [num]
        else
            if i > :math.sqrt(num) do
                list_of_factors
            else
                if rem(num, i) == 0 do
                    find_factors(trunc(num / i), i, list_of_factors ++ [i])
                else
                    find_factors(num, i + 1, list_of_factors)
                end
            end
        end
    end

    def factor(x) do
        x
        |> parse_int()
        |> find_factors(2, [])
    end

end