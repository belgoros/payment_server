defmodule PaymentServerWeb.Dataloader do
  @moduledoc false

  alias PaymentServer.Accounts

  def dataloader, do: Dataloader.add_source(Dataloader.new(), Accounts, Accounts.data())
end
