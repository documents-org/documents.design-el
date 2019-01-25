defmodule DocumentsDesignWeb.Plugs.NeedsAuth do
  import Plug.Conn
  import Phoenix.Controller

  @moduledoc """
    Guards access to unauthenticated users.
  """

  def init(_params) do
  end

  def call(conn, _params) do
    case conn.assigns[:user] do
      nil ->
        conn
        |> put_flash(:error, "You should be logged in")
        |> redirect(to: DocumentsDesignWeb.Router.Helpers.auth_path(conn, :login))
        |> halt()

      _ ->
        conn
    end
  end
end
