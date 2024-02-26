defmodule PaymentServerWeb.Router do
  use PaymentServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: PaymentServerWeb.Schema

    # interface: :playground

    forward "/", Absinthe.Plug, schema: PaymentServerWeb.Schema
  end
end
