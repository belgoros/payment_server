defmodule PaymentServer.Ledger.Transaction do
  @moduledoc false
  alias alias PaymentServer.Accounts
  alias PaymentServer.Accounts.User
  alias PaymentServer.Ledger

  def total_worth_of_wallets_for(%User{} = user, to_currency) do
    user_wallets = Accounts.get_user_wallets(user.id)
    non_convertible_wallets = Enum.filter(user_wallets, &(&1.currency == to_currency))
    convertible_wallets = user_wallets -- non_convertible_wallets

    converted_amount = get_converted_amount(convertible_wallets, to_currency)

    non_converted_amount =
      Enum.map(non_convertible_wallets, & &1.units)
      |> Enum.map(&Decimal.to_float/1)
      |> Enum.sum()
      |> Decimal.from_float()

    Decimal.add(converted_amount, non_converted_amount)
    |> Decimal.round(2)
  end

  defp get_converted_amount(wallets_to_convert, to_currency) do
    wallets_to_convert
    |> Enum.reduce(0, fn wallet, acc ->
      convert_wallet_units(wallet, to_currency, acc)
    end)
  end

  defp convert_wallet_units(wallet, to_currency, accumulator) do
    exchange_rate(wallet.currency, to_currency)
    |> Decimal.from_float()
    |> Decimal.mult(wallet.units)
    |> Decimal.add(accumulator)
  end

  defp exchange_rate(from_currency, to_currency) do
    Ledger.exchange_rate(from_currency, to_currency)
  end
end
