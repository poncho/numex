defmodule Numex.DecimalTest do
  use ExUnit.Case
  import Numex.Decimal

  test "Should add" do
    assert add(0.1, 0.2) == 0.3
  end

  test "Should substract" do
    assert sub(0.2, 0.1) == 0.1
  end
end
