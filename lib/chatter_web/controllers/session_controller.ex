defmodule ChatterWeb.SessionController do
  use ChatterWeb, :controller

  # if dont, Guardian.Plug.sign_out and Guardian.Plug.sign_in raise mismatch funtion
  alias Chatter.{Accounts, Accounts.User, Accounts.Guardian}

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)
    if maybe_user do
      redirect(conn, to: "/chat")
    else
      render(conn, "new.html", changeset: changeset, action: session_path(conn, :create))
    end
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/chat")
  end

  defp login_reply({:error, _reason}, conn) do
    conn
    |> put_flash(:error, "Wrong email/password")
    |> new(%{})
  end
end
