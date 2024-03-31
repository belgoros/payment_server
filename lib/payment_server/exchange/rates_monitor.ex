defmodule PaymentServer.Exchange.RatesMonitor do
  @moduledoc """
    This is the implementation of an exchange rates monitor server
  """
  use GenServer

  # alias PaymentServer.Exchange.AlphaVantageApi
  alias PaymentServer.Exchange.Parser

  @default_server :rates_monitor
  @refresh_interval :timer.seconds(5)

  defmodule State do
    @moduledoc """
    Exchange server state
    """
    defstruct from_currency: :usd, to_currency: :eur, rate: 1.0
  end

  # Client Interface
  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_server)
    GenServer.start_link(__MODULE__, %State{}, opts)
  end

  def get_rates(pid \\ @default_server, from_currency, to_currency) do
    GenServer.call(
      pid,
      {:get_rates, %State{from_currency: from_currency, to_currency: to_currency}}
    )
  end

  # Server Callbacks
  @impl true
  def init(old_state) do
    exchange_rates = fetch_rates(old_state)
    initial_state = Map.merge(old_state, exchange_rates)
    schedule_refresh()
    {:ok, initial_state}
  end

  @impl true
  def handle_info(:refresh, state) do
    new_state = fetch_rates(state)
    schedule_refresh()
    {:noreply, new_state}
  end

  @impl true
  def handle_call({:get_rates, state}, _from, old_state) do
    new_state = old_state
    to_caller = fetch_rates(state)
    {:reply, to_caller, new_state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp fetch_rates(%{from_currency: from_currency, to_currency: to_currency} = state) do
    api_module =
      Application.get_env(:payment_server, :api_module, PaymentServer.Exchange.AlphaVantageApi)

    response = api_module.get_rates(from_currency, to_currency)
    rate = Parser.parse(response)

    %{state | from_currency: from_currency, to_currency: to_currency, rate: rate}
  end
end
