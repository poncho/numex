defmodule Numex.FinancialTest do
  use ExUnit.Case
  import Numex.Financial

  test "fv" do
    assert 15_692.92889433575 == fv(0.05/12, 10*12, -100, -100)
  end

  test "pv" do
    assert -100.00067131625708 == pv(0.05/12, 10*12, -100, 15692.93)
  end

  test "pmt" do
    assert -1_854.024720005462 == pmt(0.075/12, 12*15, 200000)
  end
end