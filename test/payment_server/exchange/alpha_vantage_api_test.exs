defmodule PaymentServer.Exchange.AlphaVantageApiTest do
  alias PaymentServer.Exchange.AlphaVantageApi

  use ExUnit.Case, async: true
  use Mimic

  test "it should return exchange rate value " do
    AlphaVantageApi
    |> expect(:get_rate, fn _from_currency, _to_currency -> mocked_response(1.25) end)

    %{rate: rate} = AlphaVantageApi.get_rate("eur", "usd")

    assert rate == 1.25
  end

  defp mocked_response(rate) do
    %{
      rate: rate
    }
  end
end
