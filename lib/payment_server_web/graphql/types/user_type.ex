defmodule PaymentServerWeb.Graphql.Types.UserType do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "A User"
  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
  end
end
