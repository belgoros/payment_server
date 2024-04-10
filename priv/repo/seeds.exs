alias PaymentServer.Repo
alias PaymentServer.Accounts.{User, Wallet}

#
# USERS
#

mike =
  %User{}
  |> User.changeset(%{
    name: "mike",
    email: "mike@example.com"
  })
  |> Repo.insert!()

%User{}
|> User.changeset(%{
  name: "nicole",
  email: "nicole@example.com"
})
|> Repo.insert!()

%User{}
|> User.changeset(%{
  name: "hacker",
  email: "hacker@example.com"
})
|> Repo.insert!()

#
# WALLETS
#

%Wallet{}
|> Wallet.changeset(%{
  currency: :EUR,
  units: Decimal.from_float(50.0),
  user: mike,
  user_id: mike.id
})
|> Repo.insert!()

%Wallet{}
|> Wallet.changeset(%{
  currency: :USD,
  units: Decimal.from_float(100.0),
  user: mike,
  user_id: mike.id
})
|> Repo.insert!()
