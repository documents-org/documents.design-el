defmodule DocumentsDesignWeb.AdminController do
  use DocumentsDesignWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def tags(conn, _params) do
    render(conn, "tags.html")
  end

  def sequence(conn, _params) do
    render(conn, "sequence.html")
  end

  def info(conn, _params) do
    render(conn, "info.html")
  end

  def projects(conn, _params) do
    render(conn, "projects.html")
  end

  def edit_project(conn, _params) do
    render(conn, "edit_project.html")
  end

  def new_project(conn, _params) do
    render(conn, "new_project.html")
  end
end
