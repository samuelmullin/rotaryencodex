defmodule RotaryEncodex.Pin do
  @moduledoc """
  Documentation for Button.
  """
  use GenServer

  @spec start_link(%{:pin => non_neg_integer(), :name => atom()}) :: GenServer.on_start()
  def start_link(%{pin: pin, name: name}) do
    GenServer.start_link(__MODULE__, [pin, :pulldown, :both, name], name: name)
  end

  @impl true
  def init([gpio_pin, pull_mode, interrupts, name]) do
    # Button
    {:ok, gpio} = Circuits.GPIO.open(gpio_pin, :input)
    :ok = Circuits.GPIO.set_pull_mode(gpio, pull_mode)
    :ok = Circuits.GPIO.set_interrupts(gpio, interrupts)

    {:ok, %{gpio: gpio, pin: gpio_pin, name: name}}
  end

  @impl true
  def handle_info({:circuits_gpio, _gpio_pin, _timestamp, 1}, %{name: name} = state) do
    RotaryEncodex.State.set_high(name)

    {:noreply, state}
  end

  @impl true
  def handle_info({:circuits_gpio, _gpio_pin, _timestamp, 0}, %{name: name} = state) do
    RotaryEncodex.State.set_low(name)

    {:noreply, state}
  end

  @impl true
  # If you pass a third var in ms, this will happen if no messages are received before that happens
  def handle_info(:timeout, state) do
    {:noreply, state}
  end

end
