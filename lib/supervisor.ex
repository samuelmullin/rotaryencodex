defmodule Button.Supervisor do
  use Supervisor

  def deploy_robot do
    Supervisor.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do

    children = [
      worker(RotaryState, [], id: :rotary_state),
      worker(Button, [17], id: :button_dt),
      worker(Button, [18], id: :button_clk)
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
