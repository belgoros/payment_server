defmodule PaymentServer.Exchange.RateApi do
  @moduledoc """
  Handles Exchange server API calls
  """
  @callback get_rate(from_currency :: String.t(), to_currency :: String.t()) :: map()
end
