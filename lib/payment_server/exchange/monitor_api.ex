defmodule PaymentServer.Exchange.MonitorApi do
  @moduledoc """
  Handles Exchange server API calls
  """
  @callback get_rates(from_currency :: String.t(), to_currency :: String.t()) :: Map.t()
end
