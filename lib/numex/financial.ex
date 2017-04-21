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

  import Timex, only: [parse!: 2, diff: 3]

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
  @spec irr([float], float, float) :: float
  def irr(values, guess \\ 0.2, delta \\ 0.0001) do
    limit = abs(values |> Enum.at(0)) * delta
    npv_value = npv(guess, values)
    case npv_value do
      _ when abs(npv_value) < limit ->
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

  @doc """
  
  """
  @spec xirr([float], [float], float, float, float) :: float
  def xirr(values, dates, guess \\ 0.2, delta \\ 0.0001)
  def xirr(values, dates, _, _, _) when length(values) != length(dates) do
    :error
  end
  def xirr(values, dates, guess, delta) do
    limit = abs(values |> Enum.at(0)) * delta

    dates =
      dates
      |> Enum.map(&parse!(&1, "{YYYY}-{0M}-{D}"))

    date1 =
      dates
      |> Enum.at(0)

    values
    |> Enum.zip(dates)
    |> _xirr(date1, guess, delta, limit)

  end
  defp _xirr(data, date1, guess, delta, limit) do
    IO.inspect(guess, label: "GUESS")
    xirr_value = calculate_xirr(data, date1, guess)
    IO.inspect(xirr_value, label: "XIRR")
    Process.sleep(2000)
    case xirr_value do
      _ when abs(xirr_value) < limit ->
          result = (guess * 100)
          {fixed_result, _} =
            result
            |> :erlang.float_to_binary(decimals: 2)
            |> Float.parse
          fixed_result
      _ when xirr_value > 0 -> _xirr(data, date1, guess + delta, delta, limit)
      _ when xirr_value < 0 -> _xirr(data, date1, guess - delta, delta, limit)
    end
  end

  defp calculate_xirr(data, date1, guess) do
    data
    |> Enum.reduce(0.0, fn {value, date}, acc ->
        exp = (value/:math.pow((1 + guess), (diff(date, date1, :days) / 365)))
        # IO.inspect(acc, label: "ACC")
        # IO.inspect(exp, label: "NEXT")
        # Process.sleep(3000)
        acc + exp
       end)
  end

end
