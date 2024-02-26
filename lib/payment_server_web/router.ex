defmodule PaymentServerWeb.Router do
  use PaymentServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PaymentServerWeb do
    pipe_through :api
  end
end
