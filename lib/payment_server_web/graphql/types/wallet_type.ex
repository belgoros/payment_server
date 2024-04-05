defmodule PaymentServerWeb.Graphql.Types.WalletType do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias PaymentServer.Accounts

  @desc "A User wallet"
  object :wallet do
    field(:id, non_null(:id))
    field(:currency, non_null(:currency_type))
    field :units, :float
    field :user, non_null(:user), resolve: dataloader(Accounts)
  end
end
