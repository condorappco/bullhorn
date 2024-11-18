defmodule WalkyTalky do
  @moduledoc false

  import Phoenix.LiveView

  alias Phoenix.Socket
  alias WalkyTalky.Flash

  @version Mix.Project.config()[:version]

  def version, do: @version

  defmodule LiveView do
    @moduledoc false

    @spec put_flash!(Socket.t(), atom(), String.t(), Keyword.t()) :: Socket.t()
    def put_flash!(socket, kind, message, opts \\ []) do
      put_flash(socket, :flashes, [Flash.build(kind, message, opts)])
    end
  end

  defmodule LiveComponent do
    @moduledoc false

    @spec put_flash!(Socket.t(), atom(), String.t(), Keyword.t()) :: Socket.t()
    def put_flash!(socket, kind, message, opts \\ []) do
      send(self(), {:put_flash, :flashes, [Flash.build(kind, message, opts)]})

      socket
    end
  end

  defmodule Controller do
    @moduledoc false

    @spec put_flash!(Plug.Conn.t(), atom(), String.t(), Keyword.t()) :: Conn.t()
    def put_flash!(conn, kind, message, opts \\ []) do
      Phoenix.Controller.put_flash(conn, :flashes, [Flash.build(kind, message, opts)])
    end
  end
end
