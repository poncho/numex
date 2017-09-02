defmodule Numex.FinancialTest do
  @moduledoc ""

  use ExUnit.Case
  import Numex.Financial

  test "fv" do
    assert 15_692.92889433575 == fv(0.05/12, 10*12, -100, -100)
  end

  test "pv" do
    assert -100.00067131625708 == pv(0.05/12, 10*12, -100, 15_692.93)
  end

  test "npv" do
    assert -0.0084785916384548798 == npv(0.281, [-100, 39, 59, 55, 20])
  end

  test "pmt" do
    assert -1_854.024720005462 == pmt(0.075/12, 12*15, 200_000)
  end

  test "irr" do
    assert 28.09 == irr([-100, 39, 59, 55, 20])
  end
end
