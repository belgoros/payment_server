defmodule PaymentServerWeb.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias PaymentServer.Accounts

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Accounts, Accounts.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins, do: [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()

  import_types(PaymentServerWeb.Graphql.Queries.UserQueries)
  import_types(PaymentServerWeb.Graphql.Queries.WalletQueries)
  import_types(PaymentServerWeb.Graphql.Types.UserType)
  import_types(PaymentServerWeb.Graphql.Types.WalletType)
  import_types(PaymentServerWeb.Graphql.Types.WalletsTotalType)
  import_types(PaymentServerWeb.Graphql.Types.SentMoneyType)

  import_types(PaymentServerWeb.Graphql.Mutations.UserMutation)
  import_types(PaymentServerWeb.Graphql.Mutations.WalletMutation)

  query do
    import_fields(:user_queries)
    import_fields(:wallet_queries)
    import_fields(:wallets_total)
  end

  mutation do
    import_fields(:create_user_mutation)
    import_fields(:create_wallet_mutation)
  end
end
