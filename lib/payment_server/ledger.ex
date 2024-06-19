defmodule PaymentServer.Ledger do
  @moduledoc """
  Module to register payment transactions between wallets
  """

  alias PaymentServer.Accounts
  alias PaymentServer.Accounts.Wallet
  alias PaymentServer.Exchange

  def send_money(%Wallet{} = sender_wallet, %Wallet{} = receiver_wallet, amount) do
    if Decimal.lt?(sender_wallet.units, amount) do
      raise_wallet_credit_error(sender_wallet, amount)
    else
      converted_amount = convert_amount(sender_wallet, receiver_wallet, amount)

      result =
        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :update_sender,
          update_sender_step(sender_wallet, amount)
        )
        |> Ecto.Multi.update(
          :update_receiver,
          update_receiver_step(receiver_wallet, converted_amount)
        )
        |> PaymentServer.Repo.transaction()

      result
    end
  end

  defp update_sender_step(%Wallet{} = sender_wallet, amount) do
    Accounts.change_wallet(sender_wallet, %{units: Decimal.sub(sender_wallet.units, amount)})
  end

  defp update_receiver_step(%Wallet{} = receiver_wallet, amount) do
    Accounts.change_wallet(receiver_wallet, %{units: Decimal.add(amount, receiver_wallet.units)})
  end

  defp raise_wallet_credit_error(sender_wallet, amount) do
    changeset =
      Wallet.changeset(sender_wallet, %{})
      |> Ecto.Changeset.add_error(
        :units,
        "Wallet credit insufficient to send %{amount} %{currency}",
        amount: amount,
        currency: sender_wallet.currency
      )

    {:error, changeset}
  end

  defp convert_amount(sender_wallet, receiver_wallet, amount) do
    rate =
      if sender_wallet.currency == receiver_wallet.currency do
        1.0
      else
        exchange_rate(sender_wallet.currency, receiver_wallet.currency)
      end

    convert_amount_by_rate(rate, amount)
  end

  def convert_amount_by_rate(rate, amount) do
    rate
    |> Decimal.from_float()
    |> Decimal.mult(amount)
  end

  def exchange_rate(from_currency, to_currency) do
    %{rate: rate} = Exchange.get_rate(from_currency, to_currency)
    rate
  end
end
