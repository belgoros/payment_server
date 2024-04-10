defmodule PaymentServerWeb.Graphql.Types.WalletsTotalType do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "Wallets total worth in currency"
  object :wallets_total do
    field :total, :decimal
    field :currency, :currency_type
  end
end
