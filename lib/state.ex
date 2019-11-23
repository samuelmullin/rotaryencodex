defmodule RotaryEncodex.State do
  use GenServer

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: :state)
  end

  def init(initial_value) do
    {:ok, initial_value}
  end

  def set_high(pin) do
    GenServer.call(:state, {:set_high, pin})
  end

  def set_low(pin) do
    GenServer.call(:state, {:set_low, pin})
  end

  def get_value() do
    GenServer.call(:state, :get_value)
  end

  def handle_call({:set_high, :dt}, _from, %{counter: _counter, dt: :low, clk: :low} = state) do
    state = state
    |> Map.put(:dt, :high)

    {:reply, "Set pin: :dt to :high", state}
  end

  def handle_call({:set_high, :dt}, _from, %{counter: counter, dt: :low, clk: :high} = state) do
    state = state
    |> Map.put(:dt, :high)
    |> Map.put(:counter, counter - 1)

    {:reply, "Set pin: :dt to :high and decremented counter to #{counter - 1}", state}
  end

  def handle_call({:set_high, :dt}, _from, %{counter: _counter, dt: :high, clk: _clk} = state) do
    {:reply, "Pin: :dt already set to :high", state}
  end

  def handle_call({:set_high, :clk}, _from, %{counter: _counter, dt: :low, clk: :low} = state) do
    state = state
    |> Map.put(:clk, :high)

    {:reply, "Set pin: clk to :high", state}
  end

  def handle_call({:set_high, :clk}, _from, %{counter: counter, dt: :high, clk: :low} = state) do
    state = state
    |> Map.put(:clk, :high)
    |> Map.put(:counter, counter + 1)

    {:reply, "Set pin: :clk to :high and incremented counter to #{counter + 1}", state}
  end

  def handle_call({:set_high, :clk}, _from, %{counter: _counter, dt: _dt, clk: :high} = state) do
    {:reply, "Pin :clk already set to :high", state}
  end

  def handle_call({:set_low, pin}, _from, state) do
    state = state
    |> Map.put(pin, :low)

    {:reply, "Set pin #{pin} to :low", state}
  end

  def handle_call(:get_value, _from, %{counter: counter} = state) do
    {:reply, counter, state}
  end

end
