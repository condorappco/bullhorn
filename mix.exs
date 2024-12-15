defmodule Bullhorn.MixProject do
  use Mix.Project

  def project do
    [
      app: :bullhorn,
      description:
        "A @condorappco library to standardize Phoenix flash messages for live and \"dead\" views",
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ecto, "~> 3.12"},
      # {:elemental, github: "condorappco/elemental"},
      {:elemental, path: "../elemental"},
      {:phoenix_live_view, "~> 1.0"},
      # {:powertools, github: "condorappco/powertools"},
      {:powertools, path: "../powertools"},
      {:typed_struct, "~> 0.3"}
    ]
  end
end
