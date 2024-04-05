{:ok, _} = Application.ensure_all_started(:ex_machina)
Mimic.copy(PaymentServer.Exchange.AlphaVantageApi)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(PaymentServer.Repo, :manual)
