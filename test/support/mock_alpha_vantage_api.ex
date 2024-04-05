defmodule PaymentServer.Exchange.MockAlphaVantageApi do
  @moduledoc """
  Mock of the API server
  """
  @behaviour PaymentServer.Exchange.MonitorApi

  @impl true
  def get_rate(_from_currency, _to_currency) do
    %{rate: 1.50}
  end
end
