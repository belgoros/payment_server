defmodule PaymentServer.Exchange.MockAlphaVantageApiTest do
  use ExUnit.Case, async: true

  alias PaymentServer.Exchange

  test "it should call mocked API" do
    %{rate: rate} = Exchange.get_rate("eur", "usd")
    assert rate == 2.0
  end
end
