defmodule PaymentServer.Exchange.AlphaVantageApi do
  @moduledoc """
  This is a Alpha Vantage API module which provides the exchange rates data
  """
  @api_url "http://localhost:4001/query"

  def get_rates(from_currency \\ "USD", to_currency \\ "JPY") do
    {:ok, response} =
      build_search_url(from_currency, to_currency)
      |> Req.get()

    response
  end

  defp build_search_url(from_currency, to_currency) do
    URI.parse(@api_url)
    |> function_parameter()
    |> from_currency_parameter(from_currency)
    |> to_currency_parameter(to_currency)
    |> api_key_parameter()
    |> URI.to_string()
  end

  defp function_parameter(uri) do
    URI.append_query(uri, "function=#{Application.fetch_env!(:payment_server, :function)}")
  end

  defp api_key_parameter(uri) do
    URI.append_query(uri, "apikey=#{Application.fetch_env!(:payment_server, :api_key)}")
  end

  defp from_currency_parameter(uri, from_currency),
    do: URI.append_query(uri, "from_currency=#{from_currency}")

  defp to_currency_parameter(uri, to_currency),
    do: URI.append_query(uri, "to_currency=#{to_currency}")
end
