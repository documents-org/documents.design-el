defmodule DocumentsDesign.Content.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :title, :string
    field :slug, :string
    field :project_id, :integer
    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(DocumentsDesign.Utilities.slug_title(attrs), [:title, :slug])
    |> validate_required([:title, :slug])
  end
end
