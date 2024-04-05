defmodule PaymentServer.Exchange.MockAlphaVantageApi do
  @moduledoc """
  Mock of the API server
  """
  @behaviour PaymentServer.Exchange.MonitorApi

  def get_rates(_from_currency, _to_currency) do
    %Req.Response{
      status: 200,
      headers: %{
        "cache-control" => ["max-age=0, private, must-revalidate"],
        "content-type" => ["application/json"],
        "date" => ["Sun, 31 Mar 2024 19:06:19 GMT"],
        "server" => ["Cowboy"]
      },
      body: %{
        "Realtime Currency Exchange Rate" => %{
          "1. From_Currency Code" => "EUR",
          "2. From_Currency Name" => "Euro",
          "3. To_Currency Code" => "USD",
          "4. To_Currency Name" => "US Dollar",
          "5. Exchange Rate" => "3.15",
          "6. Last Refreshed" => "2024-03-31 19:06:20.304698Z",
          "7. Time Zone" => "UTC",
          "8. Bid Price" => "3.15",
          "9. Ask Price" => "3.15"
        }
      }
    }
  end
end
