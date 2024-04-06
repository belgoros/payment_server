defmodule PaymentServer.Ledger.Transaction do
  @moduledoc false
  alias alias PaymentServer.Accounts
  alias PaymentServer.Accounts.User
  alias PaymentServer.Bound

  def total_worth_of_wallets_for(%User{} = user, to_currency) do
    user_wallets = Accounts.get_user_wallets(user.id)
    non_convertible_wallets = Enum.filter(user_wallets, &(&1.currency == to_currency))
    convertible_wallets = user_wallets -- non_convertible_wallets

    converted_amount = get_converted_amount(convertible_wallets, to_currency)
    non_converted_amount = Enum.map(non_convertible_wallets, & &1.units) |> Enum.sum()

    converted_amount + non_converted_amount
  end

  defp get_converted_amount(wallets_to_convert, to_currency) do
    wallets_to_convert
    |> Enum.reduce(0, fn wallet, acc ->
      wallet.units * exchange_rate(wallet.currency, to_currency) + acc
    end)
  end

  defp exchange_rate(from_currency, to_currency) do
    %{rate: rate} = Bound.get_rate(from_currency, to_currency)
    rate
  end
end
