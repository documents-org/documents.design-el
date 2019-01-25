defmodule DocumentsDesign.Pages.Page do
  use Ecto.Schema
  import Ecto.Changeset


  schema "pages" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
