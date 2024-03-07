defmodule PaymentServerWeb.GraphQl.Types.WalletType do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "A User wallet"
  object :wallet do
    field(:id, non_null(:id))
    field(:currency, non_null(:currency_type))
  end

  @desc "Accepted currency values"
  enum :currency_type do
    value :EUR
    value :USD
    value :BTC
    value :CAT
  end
end
