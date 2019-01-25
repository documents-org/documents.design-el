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

  @doc """
  Get an user by id, without throwing.
  """
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

  @doc """
  Prepares an user for insertion when it comes from a register/reset form.
  """
  def prepare_new_user_attrs(%{"password" => p} = attrs) do
    attrs
    |> Map.put("verify_token", DocumentsDesign.Utilities.random_token())
    |> Map.put("reset_token", DocumentsDesign.Utilities.random_token())
    |> Map.put("password", hash_password(p))
  end

  @doc """
  Tries to set "verified" status to 1 when an user verifies their email.
  """
  def verify_email(email, token) do
    user = Repo.get_by(User, %{email: email, verify_token: token})

    if user do
      user
      |> Ecto.Changeset.cast(%{verified: true}, [:verified])
      |> Repo.update()
    else
      mystery_error_message()
    end
  end

  @doc """
  Tries to authentificate an user.
  """
  def auth_user(email, password) do
    user = Repo.get_by(User, %{email: email})

    if user do
      if verify_password(user, password) do
        {:ok, user}
      else
        mystery_error_message()
      end
    else
      Comeonin.Argon2.dummy_checkpw()
      mystery_error_message()
    end
  end

  @doc """
  Verifies the password for a given user.
  """
  def verify_password(user, password) do
    Comeonin.Argon2.checkpw(password, user.password)
  end

  @doc """
  Hashes a password using argon2, wraps Comeonin.
  """
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

  @doc """
  Do we have at least an user created ?
  """
  def has_user do
    Repo.one(from u in "users", select: count()) > 0
  end

  @doc """
  Launches a password reset by assigning a new reset token,
  and setting the reset date to "now".
  """
  def start_reset_password(email) do
    user = Repo.get_by(User, %{email: email})

    if user do
      user
      |> Ecto.Changeset.cast(
        %{
          reset_token: DocumentsDesign.Utilities.random_token(),
          reset_date: NaiveDateTime.utc_now()
        },
        [:reset_date, :reset_token]
      )
      |> Repo.update()

      {:ok, Repo.get_by(User, %{email: email})}
    else
      mystery_error_message()
    end
  end

  @doc """
  Does a password reset, checking email,
  reset date, reset token, then sets password.
  """
  def do_reset_password(email, token, password) do
    user = Repo.get_by(User, %{email: email, reset_token: token})
    IO.inspect(user)

    if user do
      case check_reset_date(user) do
        {:ok, user} ->
          update_password(user, password)

        {:error, _} ->
          mystery_error_message()
      end
    else
      mystery_error_message()
    end
  end

  @doc """
  Checks an user's reset password date for expiration (was it in the last 24 hours ?)
  """
  def check_reset_date(user) do
    if user.reset_date do
      case NaiveDateTime.compare(
             NaiveDateTime.utc_now(),
             NaiveDateTime.add(user.reset_date, 60 * 60 * 24)
           ) do
        :lt -> {:ok, user}
        _ -> mystery_error_message()
      end
    else
      mystery_error_message()
    end
  end

  @doc """
  Updates password, randomizes reset token, randomizes verify token.
  """
  def update_password(user, password) do
    user
    |> User.changeset(prepare_new_user_attrs(%{"password" => password}))
    |> Repo.update()
  end

  @doc """
  Standard and identical error message for every auth operation :
  You don't want to communicate that an user exists, or doesn't,
  or give too much reason on why auth/reset/verification failed.
  This prevents enumeration.
  """
  def mystery_error_message, do: {:error, "Bad Credentials"}
end
