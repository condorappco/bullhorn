defmodule WalkyTalky.FlashComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  import Phoenix.HTML
  import Elemental.Component.Icon

  alias WalkyTalky.Flash
  alias Phoenix.LiveView.JS
  alias Elemental.Utils

  def mount(socket) do
    transition =
      {"transition-all transform ease-in duration-200", Utils.default_transition_show(),
       Utils.default_transition_hide()}

    {:ok, socket |> assign(:local_flashes, []) |> assign(:transition, transition)}
  end

  def update(assigns, %{assigns: %{local_flashes: local_flashes}} = socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:local_flashes, local_flashes ++ assigns.flashes)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div
      aria-live="assertive"
      class="fixed inset-0 z-50 flex items-end px-4 py-6 pointer-events-none sm:items-start sm:p-6"
      id={@id}
    >
      <div class="flex flex-col items-center w-full space-y-4 sm:items-end">
        <div
          :for={
            %Flash{
              id: id,
              kind: kind,
              title: title,
              message: message,
              auto_dismiss_delay: auto_dismiss_delay
            } <- @local_flashes
          }
          id={"flash-#{id}"}
          phx-hook="WalkyTalky"
          data-auto-dismiss-delay={auto_dismiss_delay}
          data-dismiss-handler={
            JS.hide(to: "#flash-#{id}", transition: @transition) |> JS.push("dismiss")
          }
          phx-target={@myself}
          phx-value-id={"flash-#{id}"}
          class={"pointer-events-auto w-full max-w-sm overflow-hidden rounded-lg border-#{color(kind)}-300 bg-#{color(kind)}-10 shadow-md ring-1 ring-#{color(kind)}-300"}
          role="alert"
        >
          <% id = "flash-#{id}" %>
          <% color = color(kind) %>
          <% icon = icon_name(kind) %>
          <div class="p-4">
            <div class="flex items-start">
              <div :if={icon} class="flex-shrink-0 mr-3">
                <.icon name={icon} class={"w-6 h-6 text-#{color}-600"} />
              </div>
              <div class={"w-0 flex-1 text-#{color}-600"}>
                <p :if={title} class="font-bold font-alt"><%= title %></p>
                <p class="mt-1 text-sm font-default"><%= raw(message) %></p>
              </div>
              <div class="flex flex-shrink-0 ml-4">
                <button
                  phx-click={JS.hide(to: "##{id}", transition: @transition) |> JS.push("dismiss")}
                  phx-target={@myself}
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

  def handle_event("dismiss", %{"id" => id}, %{assigns: %{local_flashes: local_flashes}} = socket) do
    local_flashes = Enum.reject(local_flashes, fn f -> "flash-#{f.id}" == id end)

    {:noreply, assign(socket, :local_flashes, local_flashes)}
  end
end
