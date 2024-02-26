defmodule PaymentServerWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  import_types(PaymentServerWeb.Graphql.Queries.UserQueries)
  import_types(PaymentServerWeb.Graphql.Types.UserType)

  query do
    import_fields(:user_queries)
  end
end
