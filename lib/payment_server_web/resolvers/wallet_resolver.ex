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

  def total_worth_in_currency(_parent, %{user_id: user_id, currency: currency}, _resolution) do
    total =
      Accounts.get_user!(user_id)
      |> Accounts.total_worth_of_wallets_for(currency)

    {:ok, %{currency: currency, total: total}}
  end
end
