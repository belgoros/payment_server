defmodule PaymentServer.Exchange do
  @moduledoc false

  alias PaymentServer.Exchange.ApiEnvironmentHandler

  def get_rate(from_currency, to_currency) do
    ApiEnvironmentHandler.get_rate(from_currency, to_currency)
  end
end
