defmodule PaymentServerWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      import Phoenix.ChannelTest
      import PaymentServerWeb.ChannelCase

      # The default endpoint for testing
      @endpoint PaymentServerWeb.Endpoint
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
