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
    |> function_parameter()
    |> from_currency_parameter(from_currency)
    |> to_currency_parameter(to_currency)
    |> api_key_parameter()
    |> URI.to_string()
  end

  defp function_parameter(uri) do
    function_param = exchange_server_options() |> Keyword.get(:function)
    URI.append_query(uri, "function=#{function_param}")
  end

  defp api_key_parameter(uri) do
    api_key_param = exchange_server_options() |> Keyword.get(:api_key)
    URI.append_query(uri, "apikey=#{api_key_param}")
  end

  defp from_currency_parameter(uri, from_currency),
    do: URI.append_query(uri, "from_currency=#{from_currency}")

  defp to_currency_parameter(uri, to_currency),
    do: URI.append_query(uri, "to_currency=#{to_currency}")

  defp exchange_server_options(),
    do: Application.get_env(:payment_server, :exchange_server_options, [])
end
