defmodule DocumentsDesignWeb.Plugs.NeedsFirstUser do
  import Plug.Conn
  import Phoenix.Controller

  @moduledoc """
  Guards access to the app, to force the registration of a first user.
  """

  def init(_params) do
  end

  def call(conn, _params) do
    if !DocumentsDesign.Accounts.has_user() do
      conn
      |> halt()
      |> redirect(to: DocumentsDesignWeb.Router.Helpers.auth_path(conn, :register))
    else
      conn
    end
  end
end
