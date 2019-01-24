defmodule DocumentsDesign.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias DocumentsDesign.Repo

  alias DocumentsDesign.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(prepare_new_user_attrs(attrs))
    |> Repo.insert()
  end

  def prepare_new_user_attrs(%{"password" => p} = attrs) do
    attrs
    |> Map.put("verify_token", DocumentsDesign.Utilities.random_token())
    |> Map.put("password", hash_password(p))
  end

  def verify_email(email, token) do
    case Repo.get_by(User, %{email: email, verify_token: token}) do
      user ->
        Ecto.Changeset.cast(user, %{verified: true}, [:verified])
        |> Repo.update()

      nil ->
        {:error, "User not found"}
    end
  end

  def auth_user(email, password) do
    case Repo.get_by(User, %{email: email}) do
      user ->
        if verify_password(user, password) do
          {:ok, user}
        else
          {:error, "Bad credentials"}
        end

      _ ->
        Comeonin.Argon2.dummy_checkpw()
        {:error, "Bad credentials"}
    end
  end

  def verify_password(user, password) do
    Comeonin.Argon2.checkpw(password, user.password)
  end

  def hash_password(password) do
    password |> Comeonin.Argon2.hashpwsalt()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def has_user do
    Repo.one(from u in "users", select: count()) > 0
  end
end
