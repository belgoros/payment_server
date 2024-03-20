defmodule PaymentServer.Factory do
  use ExMachina.Ecto, repo: PaymentServer.Repo

  alias PaymentServer.Accounts.User
  alias PaymentServer.Accounts.Wallet

  def user_factory do
    %User{
      email: sequence(:email, &"user-#{&1}@example.com"),
      name: sequence(:name, &"user-#{&1}")
    }
  end

  def wallet_factory do
    %Wallet{
      units: 100.0,
      currency: :EUR,
      user: build(:user)
    }
  end
end
