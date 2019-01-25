defmodule DocumentsDesign.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :reset_date, :naive_datetime
    field :reset_token, :string
    field :verify_token, :string
    field :verified, :boolean
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :reset_date, :reset_token, :verify_token, :verified])
    |> validate_required([:name, :email, :password])
  end
end
