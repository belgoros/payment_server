defmodule PaymentServerWeb.Graphql.Resolvers.WalletResolver do
  @moduledoc false
  alias PaymentServer.Accounts
  alias PaymentServerWeb.Graphql.Schema.ChangesetErrors
  alias PaymentServer.Ledger.Transaction
  alias PaymentServer.Ledger

  def list_wallets(_parent, _args, _resolution) do
    wallets = Accounts.list_wallets()
    Enum.each(wallets, &publish_rates_updated(&1))
    {:ok, wallets}
  end

  def find_wallets_by_currency(_parent, %{currency: currency}, _resolution) do
    wallets_by_currency = Accounts.find_wallets_by_currency(currency)

    Enum.each(wallets_by_currency, &publish_currency_updated(&1))

    {:ok, wallets_by_currency}
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
      |> Transaction.total_worth_of_wallets_for(currency)

    {:ok, %{currency: currency, total: total}}
  end

  def send_money(
        _parent,
        %{
          sender_wallet_id: sender_wallet_id,
          receiver_wallet_id: receiver_wallet_id,
          amount: amount
        },
        _resolution
      ) do
    sender_wallet = Accounts.get_wallet!(sender_wallet_id)
    receiver_wallet = Accounts.get_wallet!(receiver_wallet_id)

    case Ledger.send_money(sender_wallet, receiver_wallet, amount) do
      {:error, changeset} ->
        {:error,
         message: "Could not send money", details: ChangesetErrors.error_details(changeset)}

      {:ok, %{update_sender: updated_sender, update_receiver: updated_receiver} = _result} ->
        publish_wallet_worth_changed(updated_sender)
        publish_wallet_worth_changed(updated_receiver)

        {:ok,
         %{
           wallet: updated_receiver,
           amount_received: amount,
           currency: updated_sender.currency,
           sender_wallet_id: sender_wallet_id
         }}
    end
  end

  defp publish_wallet_worth_changed(wallet) do
    Absinthe.Subscription.publish(
      PaymentServerWeb.Endpoint,
      wallet,
      wallet_worth_change: "wallet-#{wallet.id}"
    )
  end

  def publish_currency_updated(wallet) do
    Absinthe.Subscription.publish(
      PaymentServerWeb.Endpoint,
      wallet,
      currency_rate_update: "currency-#{wallet.currency}"
    )
  end

  def publish_rates_updated(wallet) do
    Absinthe.Subscription.publish(
      PaymentServerWeb.Endpoint,
      wallet,
      rates_update: "rates"
    )
  end
end
