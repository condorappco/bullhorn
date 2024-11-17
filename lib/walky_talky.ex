defmodule WalkyTalky do
  @moduledoc """
  Documentation for `WalkyTalky`.
  """
  import Phoenix.LiveView

  @version Mix.Project.config()[:version]

  @enforce_keys [:id, :kind, :message, :title, :auto_dismiss_delay]
  defstruct [:id, :kind, :title, :message, :auto_dismiss_delay]

  @typedoc "A walky_talky flash"
  @type t() :: %__MODULE__{
          id: String.t(),
          kind: String.t(),
          title: String.t() | nil,
          message: String.t(),
          auto_dismiss_delay: non_neg_integer() | nil
        }

  def version, do: @version

  def on_mount(_name, _params, _session, socket) do
    {:cont, attach_hook(socket, :flash, :handle_info, &maybe_receive_flash/2)}
  end

  defp maybe_receive_flash({:put_flash, type, message}, socket) do
    {:halt, put_flash(socket, type, message)}
  end

  defp maybe_receive_flash(_, socket), do: {:cont, socket}

  def build(kind, message, opts \\ []) do
    %__MODULE__{
      id: Ecto.UUID.generate(),
      kind: to_string(kind),
      message: message,
      title: opts[:title],
      auto_dismiss_delay: opts[:auto_dismiss_delay] || 0
    }
  end

  def live_view do
    quote do
      def put_flash!(socket, kind, message, opts \\ []) do
        socket
        |> put_flash(:walky_talky, [WalkyTalky.build(kind, message, opts)])
      end
    end
  end

  def live_component do
    quote do
      def put_flash!(socket, kind, message, opts \\ []) do
        send(self(), {:put_flash, :walky_talky, [WalkyTalky.build(kind, message, opts)]})
        socket
      end
    end
  end

  def controller do
    quote do
      def put_flash!(conn, kind, message, opts \\ []) do
        conn
        |> Phoenix.Controller.put_flash(:walky_talky, [WalkyTalky.build(kind, message, opts)])
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
