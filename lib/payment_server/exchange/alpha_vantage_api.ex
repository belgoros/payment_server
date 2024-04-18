defmodule PaymentServer.Exchange.AlphaVantageApi do
  @behaviour PaymentServer.Exchange.RateApi
  @moduledoc """
  This is a Alpha Vantage API module which provides the exchange rates data
  """
  @api_url "http://localhost:4001/query"

  @impl true
  def get_rate(from_currency \\ "USD", to_currency \\ "JPY") do
    {:ok, response} =
      build_search_url(from_currency, to_currency)
      |> Req.get()

    rate = parse(response)
    %{rate: rate}
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

  defp parse(%Req.Response{} = response) do
    with {:ok, 200} <- Map.fetch(response, :status),
         {:ok, body} <- Map.fetch(response, :body) do
      rate = get_in(body, ["Realtime Currency Exchange Rate", "5. Exchange Rate"])
      String.to_float(rate)
    else
      _ -> IO.puts("Error when fetching the API response")
    end
  end
end
