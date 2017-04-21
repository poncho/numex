defmodule Numex.Financial do

  @moduledoc """
    Financial Functions<br /><br />
    **Glosary**<br />
    **rate**: Rate of interest<br />
    **nper**: Number of compounding periods<br />
    **pv  **: Present value<br />
    **fv  **: Future value<br />
    **type**: When payments are due [begin: 1, end: 0]<br />
  """

  import Timex, only: [parse: 2, diff: 3]

  @when_type [begin: 1, end: 0]

  @doc """
    Compute the future value
  """
  @spec fv(float, integer, float, float, 0..1) :: float
  def fv(rate, nper, pmt, pv, type \\ :end)
  def fv(rate, nper, pmt, pv, _type) when rate == 0 do
    -(pv + pmt * nper)
  end
  def fv(rate, nper, pmt, pv, type) do
    exp1 = :math.pow((1 + rate), nper)
    exp2 = pmt * (1 + rate * @when_type[type]) / rate

    (pv * exp1 + exp2 * (exp1 - 1)) * -1

  end

  @doc """
    Compute the present value
  """
  @spec pv(float, integer, float, float, 0..1) :: float
  def pv(rate, nper, pmt, fv \\ 0.0, type \\ :end)
  def pv(rate, nper, pmt, fv, _type) when rate == 0 do
    -(fv + pmt * nper)
  end
  def pv(rate, nper, pmt, fv, type) do
    exp1 = :math.pow((1 + rate), nper)
    exp2 = pmt * (1 + rate * @when_type[type]) / rate

    -(fv + exp2 * (exp1 - 1)) / exp1
  end

  @doc """
    Returns the NPV (Net Present Value) of a cash flow series.
  """
  @spec npv(float, [float]) :: float
  def npv(rate, values) do
    values
    |> Enum.with_index
    |> Enum.reduce(0.0, fn {value, index}, acc ->
        acc + value/:math.pow((1 + rate), index) end)
  end

  @doc """
    Compute the payment against loan principal plus interest
  """
  @spec pmt(float, integer, float, float, 0..1) :: float
  def pmt(rate, nper, pv, fv \\ 0, type \\ :end)
  def pmt(rate, nper, pv, fv, _type) when rate == 0 do
    -(fv + pv) / nper
  end
  def pmt(rate, nper, pv, fv, type) do
    exp1 = :math.pow((1 + rate), nper)
    exp2 = (1 + rate * @when_type[type]) / rate

    -(fv + pv * exp1) / (exp2 * (exp1 - 1))
  end

  @doc """
    Return the Internal Rate of Return (IRR)
  """
  @spec irr([float], float, float, float) :: float
  def irr(values, guess \\ 0.2, delta \\ 0.01, range \\ 0.001) do
    investment = abs(values |> Enum.at(0))
    npv_value = npv(guess, values)
    case npv_value do
      _ when abs(npv_value) < (investment * range) ->
          result = (guess * 100)
          {fixed_result, _} =
            result
            |> :erlang.float_to_binary(decimals: 2)
            |> Float.parse
          fixed_result
      _ when npv_value > 0 -> irr(values, guess + delta)
      _ when npv_value < 0 -> irr(values, guess - delta)
    end
  end

end
