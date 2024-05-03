defmodule PaymentServer.Exchange.MockAlphaVantageApi do
  @moduledoc """
  Mock of the API server
  """
  @behaviour PaymentServer.Exchange.RateApi

  @impl true
  def get_rate(_from_currency, _to_currency) do
    %{rate: 2.0}
  end
end
