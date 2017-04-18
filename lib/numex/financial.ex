defmodule Numex.Financial do

    @when_type [begin: 1, end: 0]

    def fv(rate, nper, pmt, pv, type \\ :end)
    def fv(rate, nper, pmt, pv, _type) when rate == 0 do
        -(pv + pmt * nper)
    end
    def fv(rate, nper, pmt, pv, type) do
        val1 = pv * :math.pow((1 + rate), nper)
        val2 = pmt * (1 + rate * @when_type[type]) / rate * (:math.pow((1 + rate), nper) - 1)

        -(val1 + val2)
    end

    def pmt(rate, nper, pv, fv \\ 0, type \\ :end)
    def pmt(rate, nper, pv, fv, _type) when rate == 0 do
        -(fv + pv) / nper
    end
    def pmt(rate, nper, pv, fv, type) do
        val1 = pv * :math.pow((1 + rate), nper)
        val2 = (1 + rate * @when_type[type]) / rate * (:math.pow((1 + rate), nper) - 1)

        -(fv + val1) / val2
    end
end