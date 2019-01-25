defmodule DocumentsDesignWeb.AuthController do
  use DocumentsDesignWeb, :controller

  alias DocumentsDesign.Accounts

  plug :set_layout
  plug DocumentsDesignWeb.Plugs.SetUser when action in [:verify, :do_verify]
  plug DocumentsDesignWeb.Plugs.AlreadyHasFirstUser when action in [:register, :do_register]

  defp set_layout(conn, _) do
    conn |> put_layout("auth.html")
  end

  @doc """
  Sends an user their verification email.
  Pipeable as a plug.
  """
  def send_verify_mail(conn, user) do
    DocumentsDesign.Email.verify_email(user)
    |> DocumentsDesign.Mailer.deliver_later()

    conn
  end

  def send_reset_mail(conn, user) do
    DocumentsDesign.Email.reset_mail(user)
    |> DocumentsDesign.Mailer.deliver_later()

    conn
  end

  def send_reset_done_mail(conn, user) do
    DocumentsDesign.Email.reset_mail_done(user)
    |> DocumentsDesign.Mailer.deliver_later()

    conn
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  @doc """
  Tries to authenticate an user.
  If we succeed, set session ID and redirect to the homepage.
  """
  def do_login(conn, %{"info" => %{"email" => email, "password" => password}} = _params) do
    case Accounts.auth_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Bad credentials")
        |> redirect(to: Routes.auth_path(conn, :login))
    end

    render(conn, "login.html")
  end

  @doc """
  Logs out an user.
  """
  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def register(conn, _params) do
    render(conn, "register.html")
  end

  @doc """
  If there's no user yet, we serve this page, and allow the creation of the first user.
  """
  def do_register(conn, %{"info" => info}) do
    case Accounts.create_user(info) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> send_verify_mail(user)
        |> redirect(to: Routes.auth_path(conn, :verify))

      {:error, _} ->
        conn
        |> put_flash(:error, "Vérifiez le formulaire")
        |> redirect(Routes.auth_path(conn, :register))
    end
  end

  @doc """
  Email verification page
  """
  def verify(conn, _params) do
    render(conn, "verify_email.html")
  end

  @doc """
  Verifies an user's email address.
  """
  def do_verify(conn, %{"info" => %{"email" => email, "verify" => verify_token}}) do
    case Accounts.verify_email(email, verify_token) do
      {:ok, user} ->
        conn |> put_session(:user_id, user.id) |> redirect(to: Routes.page_path(conn, :index))

      {:error, _} ->
        redirect(conn, to: Routes.auth_path(conn, :verify))
    end
  end

  @doc """
  Forgot password page
  """
  def forgot(conn, _params) do
    render(conn, "forgot.html")
  end

  @doc """
  Sets a new token to the given e-mail, sends it via e-mail, and maybe allow to reset the password.
  """
  def do_forgot(conn, %{"info" => %{"email" => email}} = _params) do
    case Accounts.start_reset_password(email) do
      {:ok, user} ->
        conn
        |> send_reset_mail(user)
        |> put_session(:reset_email, email)
        |> redirect(to: Routes.auth_path(conn, :reset))

      {:error, _} ->
        conn |> redirect(to: Routes.auth_path(conn, :forgot))
    end
  end

  @doc """
  Password reset page after successful reset start
  """
  def reset(conn, _params) do
    render(conn, "reset.html", email: get_session(conn, :reset_email))
  end

  @doc """
  Resets an user's password. Notifies them by e-mail afterwards.
  """
  def do_reset(conn, %{"info" => %{"email" => e, "token" => t, "password" => p}} = _params) do
    case Accounts.do_reset_password(e, t, p) do
      {:ok, user} ->
        conn
        |> send_reset_done_mail(user)
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _} ->
        conn
        |> redirect(to: Routes.auth_path(conn, :reset))
    end
  end
end
