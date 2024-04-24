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
  query($currency: CurrencyType!) {
    wallets_by_currency(currency: $currency) {
     id
     currency
     units
    }
   }
  """

  @wallets_total_query """
  query($currency: CurrencyType!, $userId: ID!) {
    walletsTotal(currency: $currency, userId: $userId) {
      currency
      total
    }
  }
  """

  describe "Listing wallets" do
    test "It should return a list of wallets" do
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
                "units" => units_to_string(wallet.units)
              }
            ]
          }
        }

      assert expected === response
    end

    test "It should return a list of wallets with their users" do
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
                "units" => units_to_string(wallet.units),
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

    test "it should return a list of wallets by currency" do
      insert_list(3, :wallet, %{currency: :EUR})
      insert(:wallet, currency: :USD)

      query_input = %{
        "currency" => "EUR"
      }

      {:ok, response} =
        Absinthe.run(@wallets_by_currency_query, PaymentServerWeb.Schema, variables: query_input)

      wallets = get_in(response, [:data, "wallets_by_currency"])

      assert 3 == length(wallets)
    end
  end

  describe "wallets total" do
    test "it should return a total of user wallets in the specified currency" do
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

      query_input = %{
        "currency" => "EUR",
        "userId" => user.id
      }

      {:ok, response} =
        Absinthe.run(@wallets_total_query, PaymentServerWeb.Schema, variables: query_input)

      expected = %{
        data: %{
          "walletsTotal" => get_in(response, [:data, "walletsTotal"])
        }
      }

      assert response == expected
    end
  end
end
