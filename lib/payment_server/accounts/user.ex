defmodule PaymentServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  @available_attributes [:name, :email]
  @required_attributes [:name, :email]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_attributes)
    |> validate_required(@required_attributes)
  end
end
