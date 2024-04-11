defmodule PaymentServer.Ledger do
  @moduledoc """
  Module to register payment transactions between wallets
  """

  alias alias PaymentServer.Accounts
  alias alias PaymentServer.Accounts.Wallet
  alias PaymentServer.Bound

  def send_money(%Wallet{} = sender_wallet, %Wallet{} = receiver_wallet, amount) do
    if Decimal.lt?(sender_wallet.units, amount),
      do: raise("Wallet credit is insufficient to send #{amount} #{sender_wallet.currency}!")

    converted_amount =
      exchange_rate(sender_wallet.currency, receiver_wallet.currency)
      |> Decimal.from_float()
      |> Decimal.mult(amount)

    update_wallet(sender_wallet, %{units: Decimal.sub(sender_wallet.units, amount)})
    update_wallet(receiver_wallet, %{units: Decimal.add(converted_amount, receiver_wallet.units)})
  end

  defp exchange_rate(from_currency, to_currency) do
    %{rate: rate} = Bound.get_rate(from_currency, to_currency)
    rate
  end

  defp update_wallet(%Wallet{} = wallet, attrs) do
    Accounts.update_wallet(wallet, attrs)
  end
end
