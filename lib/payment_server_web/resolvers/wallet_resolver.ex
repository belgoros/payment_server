defmodule PaymentServerWeb.Graphql.Resolvers.WalletResolver do
  @moduledoc false
  alias PaymentServer.Accounts
  alias PaymentServerWeb.Graphql.Schema.ChangesetErrors

  def list_wallets(_parent, _args, _resolution) do
    {:ok, Accounts.list_wallets()}
  end

  def find_wallet_by_currency(_parent, %{currency: currency}, _resolution) do
    {:ok, Accounts.find_wallet_by_currency(currency)}
  end

  def create_wallet(_parent, args, _resolution) do
    case Accounts.create_wallet(args) do
      {:error, changeset} ->
        {:error,
         message: "Could not create wallet", details: ChangesetErrors.error_details(changeset)}

      {:ok, wallet} ->
        {:ok, wallet}
    end
  end
end
