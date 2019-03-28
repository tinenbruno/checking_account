defmodule CheckingAccountWeb.Router do
  use CheckingAccountWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticated_api do
    plug(:accepts, ["json"])
    plug(CheckingAccountWeb.AuthenticationPlug)
  end

  scope "/api", CheckingAccountWeb do
    pipe_through(:api)

    resources("/users", UserController, only: [:create])
    post("/users/login", UserController, :login, as: :login)
  end

  scope "/api", CheckingAccountWeb do
    pipe_through(:authenticated_api)
    post("/operations/credit", FinancialTransactionController, :credit, as: :credit)
    post("/operations/transfer", FinancialTransactionController, :transfer, as: :transfer)
    get("/balance", FinancialTransactionController, :balance, as: :balance)
  end
end
