defmodule RotaryEncodex.MixProject do
  use Mix.Project

  def project do
    [
      app: :button,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {RotaryEncodex.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
     {:circuits_gpio, "~> 0.4.3"}
    ]
  end
end
