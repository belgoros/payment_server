defmodule PaymentServer.Exchange.AlphaVantageApiTest do
  alias PaymentServer.Exchange.AlphaVantageApi

  use ExUnit.Case, async: true
  use Mimic

  test "it should return exchange rate value " do
    AlphaVantageApi
    |> expect(:get_rates, fn _from_currency, _to_currency -> mocked_response(1.25) end)

    {:ok, body} =
      AlphaVantageApi.get_rates("eur", "usd")
      |> Map.fetch(:body)

    rate = get_in(body, ["Realtime Currency Exchange Rate", "5. Exchange Rate"])
    assert rate == "1.25"
  end

  defp mocked_response(rate) do
    %Req.Response{
      status: 200,
      body: %{
        "Realtime Currency Exchange Rate" => %{
          "1. From_Currency Code" => "EUR",
          "2. From_Currency Name" => "Euro",
          "3. To_Currency Code" => "USD",
          "4. To_Currency Name" => "US Dollar",
          "5. Exchange Rate" => "#{rate}",
          "6. Last Refreshed" => "2024-03-26 13:32:48.532847Z",
          "7. Time Zone" => "UTC",
          "8. Bid Price" => "#{rate}",
          "9. Ask Price" => "#{rate}"
        }
      }
    }
  end
end
