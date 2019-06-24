defmodule ChatterWeb.UserController do
  use ChatterWeb, :controller

  alias Chatter.{Accounts, Accounts.User, Accounts.Guardian}

  #################### Without Authenication ####################

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:success, "Welcome!")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  #################### Need Authentication ####################

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    # cond do
    #   user == Guardian.Plug.current_resource(conn) ->
    #     render(conn, "show.html", user: user)
    #   :error ->
    #     conn
    #     |> put_flash(:error, "No access")
    #     |> redirect(to: user_path(conn, :index))
    # end
    render(conn, "show.html", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    # cond do
    #   user == Guardian.Plug.current_resource(conn) ->
    #     case Accounts.update_user(user, user_params) do
    #       {:ok, user} ->
    #         conn
    #         |> put_flash(:info, "User updated successfully.")
    #         |> redirect(to: user_path(conn, :show, user))
    #       {:error, %Ecto.Changeset{} = changeset} ->
    #         render(conn, "edit.html", user: user, changeset: changeset)
    #     end
    #   :error ->
    #     conn
    #     |> put_flash(:error, "No access")
    #     |> redirect(to: user_path(conn, :index))
    # end
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    # cond do
    #   user == Guardian.Plug.current_resource(conn) ->
    #     changeset = Accounts.change_user(user)
    #     render(conn, "edit.html", user: user, changeset: changeset)
    #   :error ->
    #     conn
    #     |> put_flash(:error, "No access")
    #     |> redirect(to: user_path(conn, :index))
    # end
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    # cond do
    #   user == Guardian.Plug.current_resource(conn) ->
    #     {:ok, _user} = Accounts.delete_user(user)
    #     conn
    #     |> Guardian.Plug.sign_out()
    #     |> put_flash(:info, "User deleted successfully.")
    #     |> redirect(to: session_path(conn, :new))
    #   :error ->
    #     conn
    #     |> put_flash(:error, "No access")
    #     |> redirect(to: user_path(conn, :index))
    # end
    {:ok, _user} = Accounts.delete_user(user)
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: session_path(conn, :new))
  end
end
