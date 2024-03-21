defmodule PaymentServerWeb.Graphql.Subscriptions.UserTotalWorthChangeSubscription do
  @moduledoc false

  use Absinthe.Schema.Notation

  object :user_total_worth_change_subscription do
    @desc "Subscribe to wallet worth change"
    field :wallet_worth_change, :wallet do
      arg(:wallet_id, non_null(:id))

      config(fn args, _res ->
        {:ok, topic: "wallet-#{args.wallet_id}"}
      end)

      resolve(fn wallet, _, _ -> {:ok, wallet} end)
    end
  end
end
