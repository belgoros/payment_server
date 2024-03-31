defmodule PaymentServer.Exchange.MockAlphaVantageApiTest do
  use ExUnit.Case, async: true

  test "it should call mocked API" do
    api_module =
      Application.get_env(:payment_server, :api_module, PaymentServer.Exchange.AlphaVantageApi)

    response = api_module.get_rates("eur", "usd")
    IO.inspect(response)
  end
end
