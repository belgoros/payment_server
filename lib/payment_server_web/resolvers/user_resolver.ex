defmodule PaymentServerWeb.Graphql.Resolvers.UserResolver do
  @moduledoc false
  alias PaymentServer.Accounts
  alias PaymentServerWeb.Graphql.Schema.ChangesetErrors

  def list_users(_parent, _args, _resolution) do
    {:ok, Accounts.list_users()}
  end

  def find_user(_parent, %{id: id}, _resolution) do
    {:ok, Accounts.get_user!(id)}
  end

  def create_user(_parent, args, _resolution) do
    case Accounts.create_user(args) do
      {:error, changeset} ->
        {:error,
         message: "Could not create user", details: ChangesetErrors.error_details(changeset)}

      {:ok, _user} = user_response ->
        user_response
    end
  end
end
