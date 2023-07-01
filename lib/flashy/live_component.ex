defmodule Flashy.LiveComponent do
  use Phoenix.LiveComponent

  import Decor.Icon

  alias Phoenix.LiveView.JS
  alias Decor.Utils

  def mount(socket) do
    transition =
      {"transition-all transform ease-in duration-200", Utils.default_transition_show(),
       Utils.default_transition_hide()}

    {:ok, socket |> assign(:flashy_local, []) |> assign(:transition, transition)}
  end

  def update(assigns, %{assigns: %{flashy_local: flashy_local}} = socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:flashy_local, Enum.concat(flashy_local, assigns.flashy || []))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div aria-live="assertive" class="pointer-events-none fixed inset-0 flex items-end px-4 py-6 sm:items-start sm:p-6">
      <div class="pointer-events-none flex w-full flex-col items-center space-y-4 sm:items-end">
        <div
          :for={%Flashy{id: id, kind: kind, title: title, message: message, auto_dismiss_delay: auto_dismiss_delay} <- @flashy_local}
          id={"flashy-#{id}"}
          phx-hook="Flashy"
          data-auto-dismiss-delay={auto_dismiss_delay}
          data-dismiss-handler={JS.hide(to: "#flashy-#{id}", transition: @transition) |> JS.push("dismiss")}
          phx-target={@myself}
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
                  phx-click={JS.hide(to: "#flashy-#{id}", transition: @transition) |> JS.push("dismiss")}
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

  def handle_event("dismiss", %{"id" => id}, %{assigns: %{flashy_local: flashy_local}} = socket) do
    flashy_local = Enum.reject(flashy_local, fn f -> f.id == id end)

    {:noreply, socket |> assign(:flashy_local, flashy_local)}
  end
end
