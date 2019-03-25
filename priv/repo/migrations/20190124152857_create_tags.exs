defmodule DocumentsDesign.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :title, :string
      add :slug, :string
      add :project_id, references(:projects)
      timestamps()
    end

  end
end
