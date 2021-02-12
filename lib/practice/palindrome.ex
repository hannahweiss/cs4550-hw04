defmodule Practice.Palindrome do

    def palindrome?(str) do
        if String.length(str) == 0 or String.length(str) == 1 do
            true
        else
            first = String.at(str, 0)
            last = String.at(str, String.length(str) - 1)
            if first == last do
                palindrome?(String.slice(str, 1..-2))
            else
                false
            end
        end
    end

end