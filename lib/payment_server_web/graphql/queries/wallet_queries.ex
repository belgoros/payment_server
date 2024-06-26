defmodule PaymentServerWeb.Graphql.Queries.WalletQueries do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Graphql.Resolvers

  object :wallet_queries do
    @desc "List of wallets"
    field :wallets, list_of(:wallet) do
      resolve(&Resolvers.WalletResolver.list_wallets/3)
    end

    field :wallets_by_currency, list_of(:wallet) do
      arg(:currency, non_null(:currency_type))
      resolve(&Resolvers.WalletResolver.find_wallets_by_currency/3)
    end

    field :wallets_total, :wallets_total do
      arg(:currency, non_null(:currency_type))
      arg(:user_id, non_null(:id))
      resolve(&Resolvers.WalletResolver.total_worth_in_currency/3)
    end
  end
end
