defmodule RotaryState do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
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
end
