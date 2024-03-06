defmodule PaymentServerWeb.Graphql.Resolvers.WalletResolver do
  @moduledoc false
  alias PaymentServer.Payment

  def list_wallets(_parent, _args, _resolution) do
    {:ok, Payment.list_wallets()}
  end

  def find_wallet_by_currency(_parent, %{currency: currency}, _resolution) do
    {:ok, Payment.find_wallet_by_currency(currency)}
  end
end
