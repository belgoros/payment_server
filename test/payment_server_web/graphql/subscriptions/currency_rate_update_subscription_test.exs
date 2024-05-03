defmodule PaymentServerWeb.Graphql.Subscriptions.CurrencyRateUpdateSubscriptionTest do
  @moduledoc false

  use PaymentServerWeb.ConnCase
  use PaymentServerWeb.SubscriptionCase

  @rates_update_subscription """
  subscription {
    ratesUpdate {
      id
      currency
      units
    }
  }
  """

  @wallets_query """
  query {
    wallets {
      id
      currency
      units
    }
  }
  """

  @currency_update_subscription """
    subscription {
      currencyRateUpdate(currency: EUR) {
        id
        units
        currency
        user {
          id
          email
          name
        }
      }
    }
  """

  @wallets_by_currency_query """
  query {
    walletsByCurrency(currency: EUR) {
      id
      units
      currency
      user {
        id
        email
        name
      }
    }
  }
  """

  test "a single Wallet can be subscribed to", %{socket: socket} do
    insert(:wallet)
    # setup a subscription
    ref = push_doc(socket, @rates_update_subscription)
    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    {:ok, response} =
      Absinthe.run(@wallets_query, PaymentServerWeb.Schema)

    # check to see if we got subscription data
    wallet_data = get_in(response, [:data, "wallets"]) |> List.first()

    expected = %{
      result: %{
        data: %{
          "ratesUpdate" => wallet_data
        }
      },
      subscriptionId: subscription_id
    }

    assert_push "subscription:data", push
    assert expected == push
  end

  test "a specific currency update can be subscribed to", %{socket: socket} do
    insert(:wallet, currency: :EUR)

    # setup a subscription
    ref = push_doc(socket, @currency_update_subscription)

    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    {:ok, response} =
      Absinthe.run(@wallets_by_currency_query, PaymentServerWeb.Schema)

    # check to see if we got subscription data
    wallet_data = get_in(response, [:data, "walletsByCurrency"]) |> List.first()

    expected = %{
      result: %{
        data: %{
          "currencyRateUpdate" => wallet_data
        }
      },
      subscriptionId: subscription_id
    }

    assert_push "subscription:data", push
    assert expected == push
  end
end
