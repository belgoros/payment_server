defmodule PaymentServer.Exchange.MockAlphaVantageApiTest do
  use ExUnit.Case, async: true

  test "it should call mocked API" do
    api_module =
      Application.get_env(
        :payment_server,
        :api_module,
        PaymentServer.Exchange.MockAlphaVantageApi
      )

    %{rate: rate} = api_module.get_rate("eur", "usd")
    assert rate == 1.50
  end
end
