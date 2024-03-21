defmodule PaymentServerWeb.Graphql.Subscriptions.CurrencyRateUpdateSubscription do
  @moduledoc false

  use Absinthe.Schema.Notation

  object :currency_rate_update_subscription do
    @desc "Subscribe to a specific currency rate update"
    field :currency_rate_update, :wallet do
      arg(:currency, non_null(:string))

      config(fn args, _res ->
        {:ok, topic: "currency-#{args.currency}"}
      end)

      resolve(fn wallet, _, _ -> {:ok, wallet} end)
    end
  end
end
