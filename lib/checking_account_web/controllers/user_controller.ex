defmodule CheckingAccountWeb.UserController do
  use CheckingAccountWeb, :controller

  alias CheckingAccount.Accounts
  alias CheckingAccount.Accounts.User

  action_fallback(CheckingAccountWeb.FallbackController)

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, token, _} <- Accounts.login_by_username_and_password(username, password) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    end
  end
end
