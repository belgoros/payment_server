defmodule PaymentServerWeb.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias PaymentServer.Repo

      import Ecto
      import Ecto.Query
      import PaymentServerWeb.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PaymentServer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PaymentServer.Repo, {:shared, self()})
    end

    :ok
  end
end
