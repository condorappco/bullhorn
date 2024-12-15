defmodule Mix.Tasks.Bullhorn.Setup do
  @moduledoc """
  Installs and configures bullhorn and its dependencies.

      mix bullhorn.setup
  """
  @shortdoc "Installs and configures bullhorn and its dependencies."

  use Mix.Task

  alias Powertools.UI

  def run([]), do: run_setup()
  def run(_), do: Mix.raise("Invalid arguments, expected: mix bullhorn.setup")

  def run_setup do
    UI.title("setup", :top_bottom)
    color = UI.random_color(:command)

    UI.print([
      {"Installs and configures bullhorn and its dependencies.", color},
      ""
    ])

    with {:error, _failed} <- run_checks(color) do
      IO.puts("")

      with question <- UI.ansi("Confirm setup plan and run?", color),
           true <- UI.confirm(question) do
        IO.puts("")

        # perform setup tasks

        UI.print([
          "",
          {"Setup complete! Rerunning checks to ensure there are no issues:", color},
          ""
        ])

        # re-run checks
        run_checks(color)
      else
        _ ->
          UI.print([
            "",
            {"No problem!", color},
            "",
            {"Be sure to perform the setup tasks above before using bullhorn. 🔉", color}
          ])
      end
    else
      _ ->
        [
          "",
          {"You're all set to start using bullhorn!", :green},
          "",
          [
            {"Be sure to use", :green},
            {"put_flash!/3", :light_green},
            {"or", :green},
            {"put_flash!/4", :light_green},
            {"in your", :green}
          ],
          {"controllers or LiveViews and bullhorn will take over", :green},
          {"from there. 🔉", :green}
        ]
        |> UI.print()
    end

    UI.footer()
  end

  def run_checks(_color) do
    errors = [{:error, "foo"}]
    results = []

    if Enum.empty?(errors) do
      {:ok, results}
    else
      {:error, errors}
    end
  end

  def bullhorn_js do
    """
    const Bullhorn = {
      autoCloseDelay() {
        return Number(this.el.dataset.autoCloseDelay) || 0;
      },
      dismissHandler() {
        return this.el.dataset.dismissHandler;
      },
      mounted() {
        if (this.autoCloseDelay() > 0) {
          setTimeout(() => {
            liveSocket.execJS(this.el, this.dismissHandler());
          }, this.autoCloseDelay());
        }
      },
    };

    export { Bullhorn };
    """
  end
end
