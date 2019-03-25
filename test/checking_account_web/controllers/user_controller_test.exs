defmodule CheckingAccountWeb.UserControllerTest do
  use CheckingAccountWeb.ConnCase

  alias CheckingAccount.Accounts

  @create_attrs %{
    name: "some name",
    password: "some password",
    username: "some username"
  }
  @invalid_attrs %{name: nil, password_hash: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login user" do
    setup do
      {:ok, user: fixture(:user)}
    end

    test "renders token when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.login_path(conn, :login),
          username: "some username",
          password: "some password"
        )

      assert %{"token" => token} = assert(json_response(conn, 200)["data"])
    end

    test "renders errors when password is wrong", %{conn: conn} do
      conn =
        post(conn, Routes.login_path(conn, :login),
          username: "some username",
          password: "wrong password"
        )

      assert json_response(conn, 401)["errors"] == %{"detail" => "Unauthorized"}
    end

    test "renders errors when user not found", %{conn: conn} do
      conn =
        post(conn, Routes.login_path(conn, :login),
          username: "wrong username",
          password: "wrong password"
        )

      assert json_response(conn, 404)["errors"] == %{"detail" => "Not Found"}
    end
  end
end
