defmodule PaymentServerWeb.Graphql.Queries.UserQueries do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Graphql.Resolvers

  object :user_queries do
    @desc "List of users"
    field :users, list_of(:user) do
      resolve(&Resolvers.UserResolver.list_users/3)
    end
  end
end
