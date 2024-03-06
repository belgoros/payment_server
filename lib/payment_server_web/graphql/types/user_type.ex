defmodule PaymentServerWeb.Graphql.Types.UserType do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "A User"
  object :user do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:email, non_null(:string))
  end
end
