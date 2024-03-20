defmodule PaymentServer.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PaymentServer.Repo

  alias PaymentServer.Accounts.{User, Wallet}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def send_money(%Wallet{} = sender_wallet, %Wallet{} = receiver_wallet, amount) do
    if sender_wallet.units < amount,
      do: raise("Wallet credit is insufficient to send #{amount} #{sender_wallet.currency}!")

    converted_amount = exchange_rate(sender_wallet.currency, receiver_wallet.currency) * amount

    update_wallet(receiver_wallet, %{units: converted_amount + receiver_wallet.units})
  end

  def total_worth_of_wallets_for(%User{} = user, to_currency) do
    user_wallets = get_user_wallets(user.id)
    non_convertible_wallets = Enum.filter(user_wallets, &(&1.currency == to_currency))
    convertible_wallets = user_wallets -- non_convertible_wallets

    converted_amount = get_converted_amount(convertible_wallets, to_currency)
    non_converted_amount = Enum.map(non_convertible_wallets, & &1.units) |> Enum.sum()

    converted_amount + non_converted_amount
  end

  defp get_converted_amount(wallets_to_convert, to_currency) do
    wallets_to_convert
    |> Enum.reduce(0, fn wallet, acc ->
      wallet.units * exchange_rate(wallet.currency, to_currency) + acc
    end)
  end

  defp exchange_rate(from_currency, to_currency) do
    rates_monitor_rates =
      PaymentServer.Exchange.RatesMonitor.get_rates(from_currency, to_currency)

    rates_monitor_rates.rate
  end

  defp get_user_wallets(id) do
    query = from(w in Wallet, where: w.user_id == ^id)
    Repo.all(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Returns the list of wallets.

  ## Examples

      iex> list_wallets()
      [%Wallet{}, ...]

  """
  def list_wallets do
    Repo.all(Wallet)
  end

  @doc """
  Gets a single wallet.

  Raises `Ecto.NoResultsError` if the Wallet does not exist.

  ## Examples

      iex> get_wallet!(123)
      %Wallet{}

      iex> get_wallet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet!(id), do: Repo.get!(Wallet, id)

  def find_wallet_by_currency(currency) do
    currency = currency |> String.upcase() |> String.to_atom()

    Wallet
    |> where(currency: ^currency)
    |> Repo.all()
  end

  @doc """
  Creates a wallet.

  ## Examples

      iex> create_wallet(%{field: value})
      {:ok, %Wallet{}}

      iex> create_wallet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet(attrs \\ %{}) do
    %Wallet{}
    |> Wallet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet.

  ## Examples

      iex> update_wallet(wallet, %{field: new_value})
      {:ok, %Wallet{}}

      iex> update_wallet(wallet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet(%Wallet{} = wallet, attrs) do
    wallet
    |> Wallet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wallet.

  ## Examples

      iex> delete_wallet(wallet)
      {:ok, %Wallet{}}

      iex> delete_wallet(wallet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet(%Wallet{} = wallet) do
    Repo.delete(wallet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet changes.

  ## Examples

      iex> change_wallet(wallet)
      %Ecto.Changeset{data: %Wallet{}}

  """
  def change_wallet(%Wallet{} = wallet, attrs \\ %{}) do
    Wallet.changeset(wallet, attrs)
  end

  # dataloader support
  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  defp query(queryable, _params), do: queryable
end
