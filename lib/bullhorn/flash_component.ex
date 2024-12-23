defmodule Bullhorn.FlashComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  import Twix
  import Phoenix.HTML
  import Elemental.Component.Icon

  alias Bullhorn.Flash
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
      class={
        tw([
          "fixed inset-4 z-50 flex items-end pointer-events-none sm:items-start"
        ])
      }
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
          phx-hook="Bullhorn"
          phx-mounted={
            JS.transition({"ease-out duration-300", "scale-105 opacity-0", "scale-100 opacity-100"},
              time: 300
            )
          }
          data-auto-dismiss-delay={auto_dismiss_delay}
          data-dismiss-handler={
            JS.transition({"ease-in duration-300", "scale-100 opacity-100", "scale-95 opacity-0"},
              time: 300
            )
            |> JS.push("dismiss")
          }
          phx-target={@myself}
          phx-value-id={"flash-#{id}"}
          class="z-10 pointer-events-auto w-full max-w-sm overflow-hidden rounded-lg border-accent-dark bg-accent shadow-md ring-1 ring-accent-dark"
          role="alert"
        >
          <% id = "flash-#{id}" %>
          <% icon = icon_name(kind) %>
          <div class="z-10">
            <div class="flex items-start m-4 z-10">
              <div :if={icon} class="flex-shrink-0 mr-3">
                <.icon name={icon} class="w-6 h-6 text-accent-text" />
              </div>
              <div class="w-0 flex-1 text-accent-text">
                <p :if={title} class="font-bold font-alt">{title}</p>
                <p class="mt-1 text-sm font-default">{raw(message)}</p>
              </div>
              <div class="flex flex-shrink-0 ml-4">
                <button
                  phx-click={JS.hide(to: "##{id}", transition: @transition) |> JS.push("dismiss")}
                  phx-target={@myself}
                  phx-value-id={id}
                  type="button"
                  class={tw(["inline-flex text-accent-text"])}
                >
                  <span class="sr-only">Close</span>
                  <.icon name="x_mark" class={tw(["w-5 h-5 text-accent-text-light"])} />
                </button>
              </div>
            </div>
            <div class="progress-bar bg-accent-dark h-2 w-full transition-all ease-linear"/>
          </div>
        </div>
      </div>
    </div>
    """
  end

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
