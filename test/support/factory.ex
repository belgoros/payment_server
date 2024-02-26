defmodule PaymentServer.Factory do
	use ExMachina.Ecto, repo: PaymentServer.Repo

	  alias PaymentServer.Accounts.User

	  def user_factory do
	    %User{
	      email: sequence(:email, &"user-#{&1}@example.com"),
	      name: sequence(:name, &"user-#{&1}")
	    }
	  end
end
