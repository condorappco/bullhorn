defmodule Mix.Tasks.Flashy do
  use Mix.Task

  alias Powertools.UI
  alias Powertools.Utils

  @shortdoc "Lists all available commands"
  @commands [
    Mix.Tasks.Flashy.Setup
  ]
  @table_spacing 2

  @moduledoc """
  Prints Flashy tasks and their information.

      mix flashy
  """

  @doc false
  def run(args) do
    case args do
      [] -> help()
      _ -> Mix.raise("Invalid arguments, expected: mix flashy")
    end
  end

  def help do
    color = UI.random_color(:command)

    max_length =
      Utils.calc_max_length(@commands |> Enum.map(fn module -> Mix.Task.task_name(module) end))

    UI.print([
      UI.title_text("flashy", :top),
      {"v#{Flashy.version()}", [color, :bright]},
      "",
      {"The universal flash system for Phoenix and LiveView.", [color, :bright]},
      ""
    ])

    @commands
    |> Enum.each(fn module ->
      print_command(Mix.Task.task_name(module), Mix.Task.shortdoc(module), color, max_length)
    end)

    UI.print([
      "",
      [
        {"Learn more at", [color]},
        {"https://condorapp.co/flashy", [color, :bright, :underline]},
        {"or on GitHub", [color]},
        {"@condorappco.", [color, :bright]}
      ]
    ])

    UI.footer()
  end

  defp print_command(command, description, color, padding) do
    command_name =
      command
      |> String.pad_trailing(padding + @table_spacing)
      |> UI.ansi(color)
      |> UI.ansi(:bright)

    [
      [
        "#{UI.ansi("mix", :light_white)} #{command_name}",
        UI.ansi("# #{description}", :light_black)
      ]
    ]
    |> UI.print()
  end
end
