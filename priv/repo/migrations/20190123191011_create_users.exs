defmodule DocumentsDesign.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password, :string
      add :reset_token, :string
      add :reset_date, :naive_datetime
      add :verify_token, :string
      add :verified, :boolean
      timestamps()
    end

  end
end
