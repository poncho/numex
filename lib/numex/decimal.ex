defmodule Numex.Decimal do
  
  def add(n1, n2) do
    numbers = [n1, n2]
    factor =
      Enum.reduce(numbers, 0, fn n, acc ->
         1/n > acc && 1/n || acc
      end)

    numbers
    |> Enum.reduce(0, fn n, acc ->
        (n * factor) + acc
      end)
    |> Kernel./(factor)
  end

  def sub(n1, n2) do
    numbers = [n1, n2]
    factor =
      Enum.reduce(numbers, 0, fn n, acc ->
         1/n > acc && 1/n || acc
      end)

    (n1 * factor - n2 * factor) / factor
  end
end
