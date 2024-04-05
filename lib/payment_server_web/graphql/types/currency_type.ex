defmodule PaymentServerWeb.Graphql.Types.CurrencyType do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "Accepted currency values"
  enum :currency_type do
    value(:EUR)
    value(:USD)
    value(:CAD)
    value(:GBP)
  end
end
