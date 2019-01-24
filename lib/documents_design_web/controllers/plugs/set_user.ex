defmodule DocumentsDesignWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller
  alias DocumentsDesign.Accounts
  alias DocumentsDesign.Accounts.User

  @moduledoc """
    Puts user info to the session, disambiguates by setting the same field to nil if there's no logged user.
  """

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Accounts.get_user(user_id) ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
