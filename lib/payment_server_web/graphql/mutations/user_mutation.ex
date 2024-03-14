defmodule PaymentServerWeb.Graphql.Mutations.UserMutation do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Graphql.Resolvers

  object :create_user_mutation do
    @desc "Create a user"
    field :create_user, :user do
      arg(:name, non_null(:string))
      arg(:email, non_null(:string))
      resolve(&Resolvers.UserResolver.create_user/3)
    end
  end
end
