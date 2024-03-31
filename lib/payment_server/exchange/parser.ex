defmodule PaymentServer.Exchange.Parser do
  @moduledoc """
  This is a module to parse API response data
  """

  def parse(%{} = response) do
    with {:ok, 200} <- Map.fetch(response, :status),
         {:ok, body} <- Map.fetch(response, :body) do
      rate = get_in(body, ["Realtime Currency Exchange Rate", "5. Exchange Rate"])
      String.to_float(rate)
    else
      _ -> IO.puts("Error when fetching the API response")
    end
  end
end
