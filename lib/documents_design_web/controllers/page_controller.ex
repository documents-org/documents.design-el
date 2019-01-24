defmodule DocumentsDesignWeb.PageController do
  use DocumentsDesignWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
