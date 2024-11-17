defmodule WalkyTalky.MixProject do
  use Mix.Project

  def project do
    [
      app: :walky_talky,
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
      {:ecto, "~> 3.10"},
      {:phoenix_live_view, "~> 0.18.16"},
      {:powertools, github: "condorappco/powertools"}
    ]
  end
end
