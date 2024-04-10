defmodule PaymentServerWeb.Graphql.Queries.UserQueriesTest do
  use PaymentServerWeb.ConnCase
  use PaymentServerWeb.RepoCase

  @users_query """
  query {
    users {
      id
      name
      email
    }
  }
  """

  @users_query_with_wallets """
  query {
    users {
      id
      name
      email
      wallets {
        currency
        units
      }
    }
  }
  """

  describe "List users" do
    test "It should display a list of users", %{conn: _conn} do
      user = insert(:user)

      {:ok, response} =
        Absinthe.run(@users_query, PaymentServerWeb.Schema)

      expected =
        %{
          data: %{
            "users" => [
              %{
                "id" => Integer.to_string(user.id),
                "email" => user.email,
                "name" => user.name
              }
            ]
          }
        }

      assert expected === response
    end
  end

  test "It should display a list of users with their wallets", %{conn: _conn} do
    wallet = insert(:wallet)

    {:ok, response} =
      Absinthe.run(@users_query_with_wallets, PaymentServerWeb.Schema)

    expected =
      %{
        data: %{
          "users" => [
            %{
              "id" => Integer.to_string(wallet.user.id),
              "email" => wallet.user.email,
              "name" => wallet.user.name,
              "wallets" => [
                %{
                  "currency" => Atom.to_string(wallet.currency),
                  "units" => units_to_string(wallet.units)
                }
              ]
            }
          ]
        }
      }

    assert expected === response
  end
end
