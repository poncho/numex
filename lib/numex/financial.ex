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

  @doc """
    f(x) => v/(1 + x)^t
    f'(x) => -tv(x + 1)^(-t-1)
  """
  @spec irr([float]) :: float
  def irr(values, guess \\ 0.1) do
    values
    |> Enum.with_index
    |> Enum.map_reduce(guess, &do_irr/2)
  end

  defp do_irr(value, acc), do: do_f_irr(value, acc) #/ do_dx_irr(value, acc)

  defp do_f_irr(value, acc) do
    elem(value, 0) / :math.pow((1 + acc), elem(value, 1))
  end

  defp do_dx_irr do
    :ok
  end
end
