defmodule PaymentServerWeb.Graphql.Resolvers.UserResolver do
  @moduledoc false
  alias PaymentServer.Accounts

  def list_users(_parent, _args, _resolution) do
    {:ok, Accounts.list_users()}
  end

  def find_user(_parent, %{id: id}, _resolution) do
    {:ok, Accounts.get_user!(id)}
  end
end
