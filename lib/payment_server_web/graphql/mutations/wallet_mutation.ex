defmodule PaymentServerWeb.Graphql.Mutations.WalletMutation do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Graphql.Resolvers

  object :create_wallet_mutation do
    @desc "Create a wallet"
    field :create_wallet, :wallet do
      arg(:currency, non_null(:string))
      arg(:user_id, non_null(:integer))

      resolve(&Resolvers.WalletResolver.create_wallet/3)
    end
  end
end
