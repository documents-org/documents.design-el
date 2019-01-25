defmodule DocumentsDesign.Repo.Migrations.CreatePicture do
  use Ecto.Migration

  def change do
    create table(:picture) do
      add :title, :string

      timestamps()
    end

  end
end
