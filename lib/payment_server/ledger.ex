defmodule PaymentServer.Ledger do
  @moduledoc """
  Module to register payment transactions between wallets
  """

  alias alias PaymentServer.Accounts
  alias alias PaymentServer.Accounts.Wallet
  alias PaymentServer.Bound

  def send_money(%Wallet{} = sender_wallet, %Wallet{} = receiver_wallet, amount) do
    if Decimal.lt?(sender_wallet.units, amount) do
      raise_wallet_credit_error(sender_wallet, amount)
    else
      converted_amount = convert_amount(sender_wallet, receiver_wallet, amount)
      update_wallet(sender_wallet, %{units: Decimal.sub(sender_wallet.units, amount)})

      update_wallet(receiver_wallet, %{
        units: Decimal.add(converted_amount, receiver_wallet.units)
      })
    end
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

  defp exchange_rate(from_currency, to_currency) do
    %{rate: rate} = Bound.get_rate(from_currency, to_currency)
    rate
  end

  defp update_wallet(%Wallet{} = wallet, attrs) do
    Accounts.update_wallet(wallet, attrs)
  end

  defp convert_amount(sender_wallet, receiver_wallet, amount) do
    rate =
      if sender_wallet.currency == receiver_wallet.currency do
        1.0
      else
        exchange_rate(sender_wallet.currency, receiver_wallet.currency)
      end

    rate
    |> Decimal.from_float()
    |> Decimal.mult(amount)
  end
end
