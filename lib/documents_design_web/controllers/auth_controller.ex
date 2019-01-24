defmodule DocumentsDesignWeb.AuthController do
  use DocumentsDesignWeb, :controller

  alias DocumentsDesign.Accounts
  alias DocumentsDesign.Accounts.User

  plug :set_layout
  plug :has_at_least_one_user when not (action in [:register, :do_register])

  defp set_layout(conn, _) do
    conn |> put_layout("auth.html")
  end

  defp has_at_least_one_user(conn, _) do
    if Accounts.has_user() do
      redirect(conn, to: Routes.auth_path(conn, :register))
    else
      conn
    end
  end

  defp send_verify_mail(conn) do
    DocumentsDesign.Email.verify_email(conn.assigns.user)
    |> DocumentsDesign.Mailer.deliver_later()

    conn
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def do_login(conn, %{"info" => %{"email" => email, "password" => password}}) do
    render(conn, "login.html")
  end

  def logout(conn, _params) do
  end

  def register(conn, _params) do
    render(conn, "register.html")
  end

  def do_register(conn, %{"info" => info}) do
    case Accounts.create_user(info) do
      {:ok, user} ->
        conn |> assign(:user, user) |> send_verify_mail |> render("verify_email.html")

      {:error, _} ->
        conn
        |> put_flash(:error, "Vérifiez le formulaire")
        |> redirect(Routes.auth_path(conn, :register))
    end
  end

  def forgot(conn, _params) do
  end

  def do_forgot(conn, _params) do
  end

  def reset(conn, _params) do
  end

  def do_reset(conn, _params) do
  end
end
