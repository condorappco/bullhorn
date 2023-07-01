defmodule Flashy.MixProject do
  use Mix.Project

  def project do
    [
      app: :flashy,
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
      {:decor, path: "../decor"},
      {:ecto, "~> 3.10"},
      {:phoenix_live_view, "~> 0.18.16"},
      {:powertools, path: "../powertools"},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev}
    ]
  end
end
