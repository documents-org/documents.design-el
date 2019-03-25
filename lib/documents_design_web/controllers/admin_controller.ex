defmodule DocumentsDesignWeb.AdminController do
  use DocumentsDesignWeb, :controller

  plug :set_layout

  defp set_layout(conn, _) do
    conn |> put_layout("admin.html")
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def tags(conn, _params) do
    tags = DocumentsDesign.Content.list_tags()
    render(
      conn
      |> assign(:tags, tags)
      |> assign(
        :tag_field,
        DocumentsDesign.Content.Tag.changeset(%DocumentsDesign.Content.Tag{}, %{})
      ),
      "tags.html"
    )
  end

  def add_tag(conn, %{"tag" => new_tag} = _params) do
    case DocumentsDesign.Content.create_tag(new_tag) do
      {:ok, tag} -> IO.inspect(tag)
      {:error, changeset} -> IO.inspect(changeset)
    end
    redirect(conn, to: DocumentsDesignWeb.Router.Helpers.admin_path(conn, :tags))
  end

  def delete_tag(conn, %{"id" => id}) do
    DocumentsDesign.Content.get_tag!(id) |> DocumentsDesign.Content.delete_tag
    redirect(conn, to: DocumentsDesignWeb.Router.Helpers.admin_path(conn, :tags))
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
