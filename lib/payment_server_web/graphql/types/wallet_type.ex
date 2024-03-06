defmodule PaymentServerWeb.Graphql.Types.WalletType do
  @moduledoc false
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "A User wallet"
  object :wallet do
    field(:id, non_null(:id))
    field(:currency, non_null(:string))
    field(:user, :user, resolve: dataloader(PaymentServer.Accounts, :user))
  end
end
