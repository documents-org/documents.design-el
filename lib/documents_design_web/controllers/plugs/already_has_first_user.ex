defmodule DocumentsDesignWeb.Plugs.AlreadyHasFirstUser do
  import Plug.Conn
  import Phoenix.Controller

  @moduledoc """
    Checks if our app already has a first registered user.
  """
  def init(_params) do
  end

  def call(conn, _params) do
    if DocumentsDesign.Accounts.has_user() do
      conn
      |> halt()
      |> redirect(to: DocumentsDesignWeb.Router.Helpers.page_path(conn, :index))
    else
      conn
    end
  end
end
