defmodule Bullhorn.Flash do
  @moduledoc """
  A struct representing a flash message.
  """
  import Phoenix.LiveView

  use TypedStruct

  typedstruct do
    field :id, String.t(), enforce: true
    field :kind, String.t(), enforce: true, default: "info"
    field :title, String.t(), default: nil
    field :message, String.t(), enforce: true
    field :auto_dismiss_delay, non_neg_integer(), enforce: true
  end

  @spec build(atom(), String.t(), Keyword.t()) :: Bullhorn.Flash.t()
  def build(kind, message, opts \\ []) do
    %__MODULE__{
      id: Ecto.UUID.generate(),
      kind: to_string(kind),
      message: message,
      title: opts[:title],
      auto_dismiss_delay: opts[:auto_dismiss_delay] || 5000
    }
  end

  def on_mount(_name, _params, _session, socket) do
    {:cont, attach_hook(socket, :flash, :handle_info, &maybe_receive_flash/2)}
  end

  defp maybe_receive_flash({:put_flash, type, message}, socket) do
    {:halt, put_flash(socket, type, message)}
  end

  defp maybe_receive_flash(_, socket), do: {:cont, socket}
end
