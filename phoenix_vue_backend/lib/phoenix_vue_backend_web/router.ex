defmodule PhoenixVueBackendWeb.Router do
  use PhoenixVueBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixVueBackendWeb do
    pipe_through :api
  end
end
