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

  @spec xirr([float], float) :: float
  def xirr(values, dates, guess \\ 0.1)
  def xirr([], [], _guess), do: []
  def xirr(values, dates, _guess) when length(values) != length(dates), do: :error
  def xirr(values, dates, guess) do
    dates =
      dates
      |> Enum.map(&Date.from_iso8601!/1)

    date1 = Enum.at(dates, 0)

    do_xirr(values, dates, date1, guess)
  end

  def do_xirr([], _, _, _), do: []
  def do_xirr([hv | tv], [hd | td], date1, guess) do
    [calculate_xirr(hv, hd, date1, guess) | do_xirr(tv, td, date1, guess)]
  end

  def calculate_xirr(value, date, date1, guess) do
      #value / :math.pow((1 + guess), diff_dates(date1, date)/365)
      diff_dates(date1, date)
  end

  @spec diff_dates(Date, Date) :: integer
  defp diff_dates(date1, date2) do
    #IO.inspect "#{date1.year} : #{date2.year}"
    year = abs(date1.year - date2.year)
    month = abs(date1.month - date)
  end

end
