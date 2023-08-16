defmodule Base62 do
  @base 62
  @char_set ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E",
  "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U",
  "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
  "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

  def encode(value) do
    do_encode(value, "")
  end

  defp do_encode(value, encoded) do
    cond do
      value > 0 ->
        remainder = rem(value, @base)
        encoded = "#{Enum.at(@char_set, remainder)}#{encoded}"
        new_value = div(value, @base)
        do_encode(new_value, encoded)
      true ->
        encoded
    end
  end

  def decode(value) do
    do_decode(value, 0, 1)
  end

  defp do_decode(value, decoded, factor) do
    current_value_length = String.length(value)

    cond do
      current_value_length > 0 ->
        last_char = String.at(value, -1)
        value = String.slice(value, 0, current_value_length - 1)
        decoded = decoded + (factor * Enum.find_index(@char_set, fn i -> i == last_char end))
        factor = factor * @base
        do_decode(value, decoded, factor)
      true ->
        decoded
    end
  end

end
