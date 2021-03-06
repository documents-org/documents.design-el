defmodule DocumentsDesign.Media.Video do
  use Ecto.Schema
  import Ecto.Changeset


  schema "video" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
