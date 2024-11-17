defmodule WalkyTalky.HTML do
  use Phoenix.Component

  def walky_talky(assigns) do
    ~H"""
    <.live_component
      :if={assigns[:socket]}
      id="walky_talky"
      module={WalkyTalky.LiveComponent}
      walky_talky={@flash["walky_talky"]}
    />

    <div :if={assigns[:conn]}>
      <%= live_render(@conn, WalkyTalky.LiveView, id: "walky_talky") %>
    </div>
    """
  end
end
