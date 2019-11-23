defmodule RotaryEncodex.State do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [name: __MODULE__])
  end

  def init(_args) do
    {:ok,
      %{
        dt: 0,
        clk: 0,
        counter: 0
      }
    }
  end

  def handle_call({:set, value}, _from, state) do
    {:reply, "#{value} set", state}
  end

end
