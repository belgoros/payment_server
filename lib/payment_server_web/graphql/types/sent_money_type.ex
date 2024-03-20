defmodule PaymentServerWeb.Graphql.Types.SentMoneyType do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "Send money object type"
  object :sent_money do
    field :sender_wallet_id, :id
    field :amount_received, :float
    field :wallet, :wallet
  end
end
