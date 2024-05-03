defmodule PaymentServer.Ledger.TransactionTest do
  use ExUnit.Case, async: true
  use PaymentServerWeb.ConnCase
  use PaymentServerWeb.RepoCase

  alias PaymentServer.Ledger.Transaction

  test "should calculate a wallet total worth" do
    user = insert(:user)

    insert(:wallet,
      currency: :EUR,
      units: Decimal.from_float(10.0),
      user: user
    )

    insert(:wallet,
      currency: :USD,
      units: Decimal.from_float(50.0),
      user: user
    )

    worth = Transaction.total_worth_of_wallets_for(user, :EUR)
    # see PaymentServer.Exchange.MockAlphaVantageApi for the mocked rate value
    assert Decimal.eq?(worth, Decimal.from_float(110.0))

    worth = Transaction.total_worth_of_wallets_for(user, :USD)
    assert Decimal.eq?(worth, Decimal.from_float(70.0))
  end
end
