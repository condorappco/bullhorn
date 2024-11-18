defmodule WalkyTalky do
  @moduledoc false

  import Phoenix.LiveView

  alias WalkyTalky.Flash

  @version Mix.Project.config()[:version]

  def version, do: @version

  defmodule LiveView do
    @moduledoc false

    @spec put_flash!(Phoenix.Socket.t(), atom(), String.t(), Keyword.t()) :: Phoenix.Socket.t()
    def put_flash!(socket, kind, message, opts \\ []) do
      put_flash(socket, :flashes, [Flash.build(kind, message, opts)])
    end
  end

  defmodule LiveComponent do
    @moduledoc false

    @spec put_flash!(Phoenix.Socket.t(), atom(), String.t(), Keyword.t()) :: Phoenix.Socket.t()
    def put_flash!(socket, kind, message, opts \\ []) do
      send(self(), {:put_flash, :flashes, [Flash.build(kind, message, opts)]})

      socket
    end
  end

  defmodule Controller do
    @moduledoc false

    @spec put_flash!(Plug.Conn.t(), atom(), String.t(), Keyword.t()) :: Plug.Conn.t()
    def put_flash!(conn, kind, message, opts \\ []) do
      Phoenix.Controller.put_flash(conn, :flashes, [Flash.build(kind, message, opts)])
    end
  end
end
