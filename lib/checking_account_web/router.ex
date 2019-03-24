defmodule CheckingAccountWeb.Router do
  use CheckingAccountWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CheckingAccountWeb do
    pipe_through :api
  end
end
