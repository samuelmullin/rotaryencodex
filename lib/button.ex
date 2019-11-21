defmodule Button do
  @moduledoc """
  Documentation for Button.
  """
  use GenServer

  @dt_pin 17
  @clk_pin 18


  @spec start_link(non_neg_integer()) :: GenServer.on_start()
  def start_link(gpio_pin) do
    GenServer.start_link(__MODULE__, gpio_pin)
  end

  @impl true
  def init(gpio_pin, pull_mode \\ :pulldown, interrupts \\ :both) do
    # Button
    {:ok, gpio} = Circuits.GPIO.open(gpio_pin, :input)
    :ok = Circuits.GPIO.set_pull_mode(gpio, pull_mode)
    :ok = Circuits.GPIO.set_interrupts(gpio, interrupts)

    {:ok, %{gpio: gpio, pin: gpio_pin, counter: 0, clk: 0, dt: 0}}
  end

  @impl true
  def handle_info({:circuits_gpio, gpio_pin, _timestamp, value}, %{gpio: gpio, pin: @dt_pin, counter: counter, clk: 0, dt: dt} = state) do
    state = state |> Map.replace!(:dt, 1)
    counter = counter - 1
    IO.puts("Counter down: #{counter}")

    {:noreply, state |> Map.replace!(:counter, counter)}
  end

  @impl true
  def handle_info({:circuits_gpio, gpio_pin, _timestamp, value}, %{gpio: gpio, pin: @dt_pin, counter: counter, clk: 1, dt: dt} = state) do
    {:noreply, state |> Map.replace!(:dt, 0)}
  end

  @impl true
  def handle_info({:circuits_gpio, gpio_pin, _timestamp, value}, %{gpio: gpio, pin: @clk_pin, counter: counter, clk: _clk, dt: 0} = state) do
    state = state |> Map.replace!(:clk, 1)
    counter = counter + 1
    IO.puts("Counter up: #{counter}")

    {:noreply, state |> Map.replace!(:counter, counter)}
  end

  @impl true
  def handle_info({:circuits_gpio, gpio_pin, _timestamp, value}, %{gpio: gpio, pin: @clk_pin, counter: counter, clk: _clk, dt: 1} = state) do
    {:noreply, state |> Map.replace!(:clk, 0)}
  end

  @impl true
  # If you pass a third var in ms, this will happen if no messages are received before that happens
  def handle_info(:timeout, state) do
    {:noreply, state}
  end

end
