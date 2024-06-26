defmodule PaymentServer.Accounts.Wallet do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PaymentServer.Accounts.User

  schema "wallets" do
    field :currency, Ecto.Enum,
      values:
        Application.compile_env(:payment_server, :accepted_currencies, [:EUR, :USD, :CAD, :GBP])

    field :units, :decimal, default: Decimal.from_float(0.0)
    belongs_to :user, User

    timestamps()
  end

  @available_attributes [:currency, :units, :user_id]
  @required_attributes [:currency, :units, :user_id]

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, @available_attributes)
    |> validate_required(@required_attributes)
    |> assoc_constraint(:user)
    |> unique_constraint(:currency,
      message: "User already has the wallet with the same currency!",
      name: :wallets_user_id_currency_index
    )
  end
end
