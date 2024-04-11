defmodule PaymentServer.Exchange.MockAlphaVantageApiTest do
  use ExUnit.Case, async: true

  alias PaymentServer.Bound

  test "it should call mocked API" do
    %{rate: rate} = Bound.get_rate("eur", "usd")
    assert rate == 1.50
  end
end
