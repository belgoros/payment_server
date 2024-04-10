defmodule PaymentServer.TestHelpers do
  def units_to_string(units) do
    Decimal.round(units, 2) |> Decimal.to_string()
  end
end
