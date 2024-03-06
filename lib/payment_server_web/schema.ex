defmodule PaymentServerWeb.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias PaymentServerWeb.Dataloader

  def context(ctx), do: Map.put(ctx, :loader, Dataloader.dataloader())

  def plugins, do: [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()

  import_types(PaymentServerWeb.Graphql.Queries.UserQueries)
  import_types(PaymentServerWeb.Graphql.Queries.WalletQueries)
  import_types(PaymentServerWeb.Graphql.Types.UserType)
  import_types(PaymentServerWeb.Graphql.Types.WalletType)

  query do
    import_fields(:user_queries)
    import_fields(:wallet_queries)
  end
end
