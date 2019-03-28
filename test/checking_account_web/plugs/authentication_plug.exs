defmodule CheckingAccountWeb.AuthenticationPlugTest do
  use CheckingAccountWeb.ConnCase
  alias CheckingAccountWeb.AuthenticationPlug
  import CheckingAccount.Fixtures, only: [user_fixture: 0]

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(CheckingAccountWeb.Router, [:api])
      |> post("/api/operations/credit")

    {:ok, %{conn: conn}}
  end

  describe "authentication" do
    test "halts when authorization header is not found", %{conn: conn} do
      conn = AuthenticationPlug.call(conn, [])
      assert conn.halted
    end

    test "halts when token is invalid", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "123")
        |> AuthenticationPlug.call([])

      assert conn.halted
    end

    test "stores user from token on conn assigns and continues", %{conn: conn} do
      {:ok, token, _} =
        user_fixture()
        |> CheckingAccount.Guardian.encode_and_sign()

      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> token)
        |> AuthenticationPlug.call([])

      refute conn.halted
      assert conn.assigns[:current_user].name == "some name"
    end
  end
end
