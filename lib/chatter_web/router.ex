defmodule ChatterWeb.Router do
  use ChatterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Our pipeline implements "maybe" authenticated.
  # We'll use the `:ensure_auth` below for when we
  # need to make sure someone is logged in.
  pipeline :auth do
    plug Chatter.Accounts.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", ChatterWeb do
    pipe_through [:browser, :auth] # Use the default browser stack

    get "/", SessionController, :new
    # post "/", SessionController, :create
    # delete "/", SessionController, :delete
    resources "/", SessionController, only: [:create, :delete]
    resources "/users", UserController, only: [:new, :create]
  end

  # Definitely logged in scope
  scope "/", ChatterWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    resources "/users", UserController, except: [:new, :create]
    get "/chat", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatterWeb do
  #   pipe_through :api
  # end
end
