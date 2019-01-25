defmodule DocumentsDesign.Repo.Migrations.CreateVideo do
  use Ecto.Migration

  def change do
    create table(:video) do
      add :title, :string

      timestamps()
    end

  end
end
