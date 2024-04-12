defmodule PaymentServer.LedgerTest do
  use ExUnit.Case, async: true
  use PaymentServerWeb.ConnCase
  use PaymentServerWeb.RepoCase

  alias PaymentServer.Ledger
  alias PaymentServer.Accounts

  describe "sending money" do
    test "same currency: it should update sender and receiver wallets balance with success" do
      sender_wallet = insert(:wallet, units: Decimal.new(50), currency: :EUR)
      receiver_wallet = insert(:wallet, units: Decimal.new(50), currency: :EUR)

      Ledger.send_money(sender_wallet, receiver_wallet, Decimal.new(10))

      updated_sender_wallet = Accounts.get_wallet!(sender_wallet.id)
      updated_receiver_wallet = Accounts.get_wallet!(receiver_wallet.id)

      assert Decimal.eq?(updated_sender_wallet.units, 40)
      assert Decimal.eq?(updated_receiver_wallet.units, 60)
    end
  end

  test "different currency: it should update sender and receiver wallets balance with success" do
    sender_wallet = insert(:wallet, units: Decimal.new(50), currency: :USD)
    receiver_wallet = insert(:wallet, units: Decimal.new(50), currency: :EUR)

    Ledger.send_money(sender_wallet, receiver_wallet, Decimal.new(10))

    updated_sender_wallet = Accounts.get_wallet!(sender_wallet.id)
    updated_receiver_wallet = Accounts.get_wallet!(receiver_wallet.id)

    assert Decimal.eq?(updated_sender_wallet.units, 30)
    assert Decimal.eq?(updated_receiver_wallet.units, 70)
  end
end
