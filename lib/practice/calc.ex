defmodule Practice.Calc do

  # TODO: deal with invalid input
  # TODO: add comments

  # Attribution for is_numeric function: https://rosettacode.org/wiki/Determine_if_a_string_is_numeric#Elixir
  def is_numeric(text) do
    case Float.parse(text) do
      {_num, ""} -> true
      _          -> false
    end
  end

  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end


  def parse_token(text) do
    case is_numeric(text) do
      true -> {:num, parse_float(text)}
      false -> 
        case text do
          "+" -> {:op, text}
          "-" -> {:op, text}
          "*" -> {:op, text}
          "/" -> {:op, text}
          x -> false
        end
    end
  end

  def tag_tokens(token_list) do
    Enum.map(token_list, fn(x) -> parse_token(x) end)
  end

  # checks if a is a higher precedence operator than b
  def has_higher_precedence(a, b) do 
    case a do
      {:op, "+"} -> false
      {:op, "-"} -> false
      {:op, x} ->
        case b do
          {:op, "+"} -> true
          {:op, "-"} -> true
          {:op, x} -> false
        end
    end
  end

  # attribution for infix to postfix algorithm: http://csis.pace.edu/~wolf/CS122/infix-postfix.htm
  def infix_to_postfix(token_list, operation_stack, expression_stack) do
    # first round -> evaluate all multiplication and division
    if length(token_list) == 0 do
      if length(operation_stack) == 0 do
        expression_stack
      else
        [operation_first | operation_rest] = operation_stack
        infix_to_postfix(token_list, operation_rest, [operation_first] ++ expression_stack)
      end
    else
      [token_first | token_rest] = token_list
      case token_first do
        {:num, x} -> infix_to_postfix(token_rest, operation_stack, [token_first] ++ expression_stack)
        {:op, x} ->
          if length(operation_stack) == 0 do
            infix_to_postfix(token_rest, [token_first], expression_stack)
          else
            if has_higher_precedence(token_first, hd(operation_stack)) do
              infix_to_postfix(token_rest, [token_first] ++ operation_stack, expression_stack)
            else
              infix_to_postfix(token_list, tl(operation_stack), [hd(operation_stack)] ++ expression_stack)
            end
          end
      end

    end

    # second round -> evaluate all addition and subtraction
  end

  def postfix_eval(token_list, stack) do
    if length(token_list) == 0 do
      hd(stack)
    else
      case hd(token_list) do
        {:num, x} -> postfix_eval(tl(token_list), [x] ++ stack)
        {:op, x} ->
          [a | rest] = stack
          [b | final] = rest
          case x do
            "+" -> postfix_eval(tl(token_list), [(b + a)] ++ final)
            "-" -> postfix_eval(tl(token_list), [(b - a)] ++ final)
            "*" -> postfix_eval(tl(token_list), [(b * a)] ++ final)
            "/" -> postfix_eval(tl(token_list), [(b / a)] ++ final)
          end
      end
    end
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(" ")
    |> tag_tokens
    |> infix_to_postfix([], [])
    |> Enum.reverse()
    |> postfix_eval([])

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
