defmodule PaymentServer.Bound do
  @moduledoc false
  def get_rate(from_currency, to_currency) do
    exchange_api_impl().get_rate(from_currency, to_currency)
  end

  defp exchange_api_impl() do
    Application.get_env(:payment_server, :exchange_api, PaymentServer.Exchange.AlphaVantageApi)
  end
end
