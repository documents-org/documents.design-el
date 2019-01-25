defmodule DocumentsDesign.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string

      timestamps()
    end

  end
end
