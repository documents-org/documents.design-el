defmodule DocumentsDesign.Content.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :title, :string
    field :slug, :string
    field :text, :string
    field :content, :map
    has_many :tags, DocumentsDesign.Content.Tag
    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
