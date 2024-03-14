defmodule PaymentServerWeb.Graphql.Queries.WalletQueries do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Graphql.Resolvers

  object :wallet_queries do
    @desc "List of wallets"
    field :wallets, list_of(:wallet) do
      resolve(&Resolvers.WalletResolver.list_wallets/3)
    end

    field :wallet, list_of(:wallet) do
      arg(:currency, non_null(:string))
      resolve(&Resolvers.WalletResolver.find_wallet_by_currency/3)
    end
  end
end
