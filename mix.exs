defmodule RotaryEncodex.MixProject do
  use Mix.Project

  def project do
    [
      app: :rotaryencodex,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "RotaryEncodex",
      source_url: "https://github.com/samuelmullin/rotaryencodex"
    ]
  end

  def application do
    [
      mod: {RotaryEncodex.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
     {:circuits_gpio, "~> 0.4.3"},
     {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "A simple package to collect input from a rotary encoder from a Raspberry Pi or similar device."
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/samuelmullin/rotaryencodex"}
    ]
  end
end
