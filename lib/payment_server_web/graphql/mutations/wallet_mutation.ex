defmodule PaymentServerWeb.Graphql.Mutations.WalletMutation do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Graphql.Resolvers

  object :create_wallet_mutation do
    @desc "Create a wallet"
    field :create_wallet, :wallet do
      arg(:currency, non_null(:currency_type))
      arg(:user_id, non_null(:id))
      arg(:units, :float)

      resolve(&Resolvers.WalletResolver.create_wallet/3)
    end

    @desc "Send money from wallet to wallet"
    field :send_money, :sent_money do
      arg(:sender_wallet_id, non_null(:id))
      arg(:receiver_wallet_id, non_null(:id))
      arg(:amount, non_null(:float))

      resolve(&Resolvers.WalletResolver.send_money/3)
    end
  end
end
