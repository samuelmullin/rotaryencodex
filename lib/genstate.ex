defmodule RotaryEncodex.GenState do
  use GenServer

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: :genstate)
  end

  def init(initial_value) do
    {:ok, initial_value}
  end

  def handle_call({:set_high, :dt}, _from, %{counter: counter, dt: :low, clk: :low} = state) do
    state = state
    |> Map.put(:dt, :high)
    |> Map.put(:counter, counter + 1)

    IO.puts("Counter: #{counter + 1}")
    {:reply, "Counter: #{counter + 1}, State: #{inspect(state)}", state}
  end

  def handle_call({:set_high, :dt}, _from, %{counter: _counter, dt: :low, clk: :high} = state) do
    state = state
    |> Map.put(:dt, :low)
    |> Map.put(:clk, :low)

    {:reply, "State: #{inspect(state)}", state}
  end

  def handle_call({:set_high, :dt}, _from, %{counter: _counter, dt: :high, clk: _clk} = state) do
    {:reply, "State: #{inspect(state)}", state}
  end

  def handle_call({:set_high, :clk}, _from, %{counter: counter, dt: :low, clk: :low} = state) do
    state = state
    |> Map.put(:clk, :high)
    |> Map.put(:counter, counter - 1)

    IO.puts("Counter: #{counter - 1}")
    {:reply, "Counter: #{counter - 1}, State: #{inspect(state)}", state}
  end

  def handle_call({:set_high, :clk}, _from, %{counter: _counter, dt: :high, clk: :low} = state) do
    state = state
    |> Map.put(:dt, :low)
    |> Map.put(:clk, :low)

    {:reply, "State: #{inspect(state)}", state}
  end

  def handle_call({:set_high, :clk}, _from, %{counter: _counter, dt: _dt, clk: :high} = state) do
    {:reply, "State: #{inspect(state)}", state}
  end

  def handle_call({:set_low, _pin}, _from, state) do
    {:reply, "State: #{inspect(state)}", state}
  end

end
