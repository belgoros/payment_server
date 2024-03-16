defmodule PaymentServerWeb.Graphql.Queries.WalletQueriesTest do
  use PaymentServerWeb.ConnCase
  use PaymentServerWeb.RepoCase

  @wallets_query """
  query {
    wallets {
      id
      currency
      units
    }
  }
  """

  @wallets_query_with_user """
  query {
    wallets {
      id
      currency
      units
      user {
        email
        name
      }
    }
  }
  """

  @wallets_by_currency_query """
  query {
    wallet(currency: "eur") {
     id
     currency
     units
    }
   }
  """

  describe "List wallets" do
    test "It should return a list of wallets", %{conn: _conn} do
      wallet = insert(:wallet)

      {:ok, response} =
        Absinthe.run(@wallets_query, PaymentServerWeb.Schema)

      expected =
        %{
          data: %{
            "wallets" => [
              %{
                "id" => Integer.to_string(wallet.id),
                "currency" => Atom.to_string(wallet.currency),
                "units" => wallet.units
              }
            ]
          }
        }

      assert expected === response
    end
  end

  test "It should return a list of wallets with their users", %{conn: _conn} do
    wallet = insert(:wallet)

    {:ok, response} =
      Absinthe.run(@wallets_query_with_user, PaymentServerWeb.Schema)

    expected =
      %{
        data: %{
          "wallets" => [
            %{
              "id" => Integer.to_string(wallet.id),
              "currency" => Atom.to_string(wallet.currency),
              "units" => wallet.units,
              "user" => %{
                "email" => wallet.user.email,
                "name" => wallet.user.name
              }
            }
          ]
        }
      }

    assert expected === response
  end

  test "It should return a list of wallets by currency", %{conn: _conn} do
    insert_list(3, :wallet, %{currency: "EUR"})
    insert(:wallet, currency: "USD")

    {:ok, response} =
      Absinthe.run(@wallets_by_currency_query, PaymentServerWeb.Schema)

    wallets = get_in(response, [:data, "wallet"])

    assert 3 == length(wallets)
  end
end
