defmodule CheckingAccountWeb.UserView do
  use CheckingAccountWeb, :view
  alias CheckingAccountWeb.UserView

  def render("create.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, username: user.username}
  end

  def render("login.json", %{token: token}) do
    %{data: %{token: token}}
  end
end
