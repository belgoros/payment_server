defmodule PaymentServerWeb.GraphQl.Resolvers.WalletResolver do
  @moduledoc false
  alias PaymentServer.Accounts

  def list_wallets(_parent, _args, _resolution) do
    {:ok, Accounts.list_wallets()}
  end

  def find_wallet_by_currency(_parent, %{currency: currency}, _resolution) do
    {:ok, Accounts.find_wallet_by_currency(currency)}
  end
end
