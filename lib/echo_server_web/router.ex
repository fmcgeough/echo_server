defmodule EchoServerWeb.Router do
  use EchoServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EchoServerWeb do
    pipe_through :browser
    get "/", PageController, :index
    live "/status", EchoLive
  end

  # Other scopes may use custom stacks.
  scope "/api", EchoServerWeb do
    pipe_through :api
    post "/callback", CallbackController, :create
    post "/callback/update_params", CallbackController, :update_params
  end
end
