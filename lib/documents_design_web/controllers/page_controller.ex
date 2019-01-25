defmodule DocumentsDesignWeb.PageController do
  use DocumentsDesignWeb, :controller

  plug :set_layout

  defp set_layout(conn, _) do
    conn |> put_layout("home.html")
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def projects(conn, _params) do
    render(conn, "projects.html")
  end

  def project(conn, _params) do
    render(conn, "project.html")
  end
end
