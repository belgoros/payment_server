defmodule PaymentServer.Exchange.RatesMonitor do
  @moduledoc """
    This is the implementation of an exchange rates monitor server
  """
  use GenServer

  alias PaymentServer.Exchange

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

  def get_rate(pid \\ @default_server, from_currency, to_currency) do
    GenServer.call(
      pid,
      {:get_rate, %State{from_currency: from_currency, to_currency: to_currency}}
    )
  end

  # Server Callbacks
  @impl true
  def init(old_state) do
    exchange_rate = fetch_rate(old_state)
    initial_state = Map.merge(old_state, exchange_rate)
    schedule_refresh()
    {:ok, initial_state}
  end

  @impl true
  def handle_info(:refresh, state) do
    new_state = fetch_rate(state)
    schedule_refresh()
    {:noreply, new_state}
  end

  @impl true
  def handle_call(
        {:get_rate, %State{from_currency: from_currency, to_currency: to_currency}},
        _from,
        state
      ) do
    task =
      Task.Supervisor.async_nolink(PaymentServer.RatesMonitorTaskSupervisor, fn ->
        Exchange.get_rate(from_currency, to_currency)
      end)

    {:reply, Task.await(task), state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp fetch_rate(%{from_currency: from_currency, to_currency: to_currency} = state) do
    %{rate: rate} = Exchange.get_rate(from_currency, to_currency)

    %{state | from_currency: from_currency, to_currency: to_currency, rate: rate}
  end
end
