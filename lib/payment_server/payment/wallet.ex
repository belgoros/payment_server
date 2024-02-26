defmodule PaymentServer.Payment.Wallet do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PaymentServer.Accounts.User

  schema "wallets" do
    field :currency, Ecto.Enum, values: [:EUR, :USD, :CAD, :BTC]
    field :units, :integer
    belongs_to :user, User

    timestamps()
  end

  @available_attributes [:currency, :units, :user_id]
  @required_attributes [:currency, :units, :user_id]
  # use Ecto.Enum.values(PaymentServer.Payment.Wallet, :currency)
  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, @available_attributes)
    |> validate_required(@required_attributes)
    |> unique_constraint(:currency,
      message: "User already has the wallet with the same currency!",
      name: :wallets_user_id_currency_index
    )
  end
end
