defmodule PaymentServerWeb.Graphql.Types.UserType do
  @moduledoc false
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias PaymentServer.Accounts

  @desc "A User"
  object :user do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:email, non_null(:string))
    field :wallets, list_of(:wallet), resolve: dataloader(Accounts)
  end
end
