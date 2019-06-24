defmodule ChatterWeb.ViewHelper do
  alias Chatter.Accounts.Guardian # if dont, Guardian.Plug.authenticated?(conn) raise mismatch funtion

  def current_user(conn), do: Guardian.Plug.current_resource(conn)
  def logged_in?(conn), do: Guardian.Plug.authenticated?(conn)
end
