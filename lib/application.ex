defmodule RotaryEncodex.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Supervisor.child_spec({RotaryEncodex.State, %{dt: :low, clk: :low, counter: 0}}, id: :state),
      Supervisor.child_spec({RotaryEncodex.Pin, %{pin: 17, name: :dt}}, id: :dt),
      Supervisor.child_spec({RotaryEncodex.Pin, %{pin: 18, name: :clk}}, id: :clk)
    ]

    opts = [strategy: :one_for_one, name: RotaryEncodex.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
