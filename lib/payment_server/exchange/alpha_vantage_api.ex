defmodule PaymentServer.Exchange.AlphaVantageApi do
  @behaviour PaymentServer.Exchange.MonitorApi
  @moduledoc """
  This is a Alpha Vantage API module which provides the exchange rates data
  """
  @api_url "http://localhost:4001/query"

  @impl true
  def get_rates(from_currency \\ "USD", to_currency \\ "JPY") do
    {:ok, response} =
      build_search_url(from_currency, to_currency)
      |> Req.get()

    response
  end

  defp build_search_url(from_currency, to_currency) do
    URI.parse(@api_url)
    |> URI.append_query(query_params(from_currency, to_currency))
    |> URI.to_string()
  end

  defp query_params(from_currency, to_currency) do
    exchange_server_options()
    |> Enum.into(%{})
    |> Map.put_new(:from_currency, from_currency)
    |> Map.put_new(:to_currency, to_currency)
    |> URI.encode_query() 
  end

  defp exchange_server_options(),
    do: Application.get_env(:payment_server, :exchange_server_options, [])
end
