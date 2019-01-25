defmodule DocumentsDesign.Media.Picture do
  use Ecto.Schema
  import Ecto.Changeset


  schema "picture" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(picture, attrs) do
    picture
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
