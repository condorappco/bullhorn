defmodule WalkyTalky.LiveView do
  use Phoenix.LiveView

  import Elemental.Icon

  alias Phoenix.LiveView.JS
  alias Elemental.Utils

  def mount(_params, session, %{assigns: %{flash: flash}} = socket) do
    transition =
      {"transition-all transform ease-in duration-200", Utils.default_transition_show(),
       Utils.default_transition_hide()}

    socket =
      socket
      |> assign(:transition, transition)
      |> assign(:walky_talky_local, flash["walky_talky"] || [])

    {:ok, socket, layout: false}
  end

  def render(assigns) do
    ~H"""
    <div
      aria-live="assertive"
      class="pointer-events-none fixed inset-0 flex items-end px-4 py-6 sm:items-start sm:p-6"
    >
      <div class="pointer-events-none flex w-full flex-col items-center space-y-4 sm:items-end">
        <div
          :for={
            %WalkyTalky{
              id: id,
              kind: kind,
              title: title,
              message: message,
              auto_dismiss_delay: auto_dismiss_delay
            } <- @walky_talky_local
          }
          id={"walky-talky-#{id}"}
          phx-hook="WalkyTalky"
          data-auto-dismiss-delay={auto_dismiss_delay}
          data-dismiss-handler={
            JS.hide(to: "#walky-talky-#{id}", transition: @transition) |> JS.push("dismiss")
          }
          phx-value-id={id}
          class={"pointer-events-auto w-full max-w-sm overflow-hidden rounded-lg border-#{color(kind)}-300 bg-#{color(kind)}-10 shadow-md ring-1 ring-#{color(kind)}-300"}
          role="alert"
        >
          <% color = color(kind) %>
          <% icon = icon_name(kind) %>
          <div class="p-4">
            <div class="flex items-start">
              <div :if={icon} class="flex-shrink-0 mr-3">
                <.icon name={icon} class={"w-6 h-6 text-#{color}-600"} />
              </div>
              <div class={"w-0 flex-1 text-#{color}-600"}>
                <p :if={title} class="font-bold font-alt"><%= title %></p>
                <p class="mt-1 text-sm font-default"><%= message %></p>
              </div>
              <div class="ml-4 flex flex-shrink-0">
                <button
                  phx-click={
                    JS.hide(to: "#walky-talky-#{id}", transition: @transition) |> JS.push("dismiss")
                  }
                  phx-value-id={id}
                  type="button"
                  class={"inline-flex rounded-md text-#{color}-400 hover:text-#{color}-600 focus:outline-none focus:ring-2 focus:ring-#{color}-600 focus:ring-offset-2"}
                >
                  <span class="sr-only">Close</span>
                  <.icon name="x_mark" class={"w-5 h-5 text-#{color}-400"} />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp color("error"), do: "red"
  defp color("success"), do: "green"
  defp color("info"), do: "purple"
  defp color("warning"), do: "orange"
  defp color(_), do: "gray"

  defp icon_name("error"), do: "x_circle"
  defp icon_name("success"), do: "check_circle"
  defp icon_name("info"), do: "information_circle"
  defp icon_name("warning"), do: "exclamation_triangle"
  defp icon_name(_), do: nil

  def handle_event(
        "dismiss",
        %{"id" => id},
        %{assigns: %{walky_talky_local: walky_talky_local}} = socket
      ) do
    walky_talky_local = Enum.reject(walky_talky_local, fn f -> f.id == id end)

    {:noreply, socket |> assign(:walky_talky_local, walky_talky_local)}
  end
end
