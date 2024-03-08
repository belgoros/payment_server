defmodule PaymentServer.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PaymentServer.Accounts.Wallet

  schema "users" do
    field :email, :string
    field :name, :string
    has_many :wallets, Wallet

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
