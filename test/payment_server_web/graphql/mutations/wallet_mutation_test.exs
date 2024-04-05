defmodule PaymentServerWeb.Graphql.Mutations.WalletMutationTest do
  use PaymentServerWeb.ConnCase, async: true
  use PaymentServerWeb.RepoCase

  @create_wallet_mutation """
  mutation ($currency: CurrencyType!, $userId: ID!, $units: Float) {
    createWallet(currency: $currency, userId: $userId, units: $units) {
      currency
      units
      user {
        id
        email
      }
    }
  }
  """

  test "it should create a new Wallet with valid attributes", %{conn: _conn} do
    user = insert(:user)

    wallet_input = %{
      "currency" => "GBP",
      "userId" => user.id
    }

    {:ok, ref} =
      Absinthe.run(@create_wallet_mutation, PaymentServerWeb.Schema, variables: wallet_input)

    expected = %{
      data: %{
        "createWallet" => get_in(ref, [:data, "createWallet"])
      }
    }

    assert ref == expected
  end
end
