defmodule PaymentServer.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :currency, :string
      add :units, :decimal, default: 0.0, precision: 10, scale: 2
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:wallets, [:user_id, :currency], unique: true)
  end
end
