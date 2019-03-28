defmodule CheckingAccountWeb.FinancialTransactionControllerTest do
  use CheckingAccountWeb.ConnCase
  alias CheckingAccount.Repo
  alias CheckingAccount.Operations

  import CheckingAccount.Fixtures,
    only: [
      bank_account_fixture: 0
    ]

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup %{conn: conn} = config do
    bank_account =
      bank_account_fixture()
      |> Repo.preload(:user)

    if config[:logged_in] do
      {:ok, token, _} = CheckingAccount.Guardian.encode_and_sign(bank_account.user)

      conn =
        conn
        |> put_req_header(
          "authorization",
          "Bearer " <> token
        )

      {:ok, conn: conn, bank_account: bank_account}
    else
      {:ok, bank_account: bank_account}
    end
  end

  describe "credit operation" do
    @credit_attrs %{
      amount: 12.34,
      description: "salary",
      destination_account_id: nil
    }

    @tag :logged_in
    test "creates a credit operation when data is valid", %{
      conn: conn,
      bank_account: bank_account
    } do
      conn =
        post(conn, Routes.credit_path(conn, :credit),
          operation: %{
            @credit_attrs
            | destination_account_id: bank_account.id
          }
        )

      assert %{"id" => id, "description" => "salary"} = json_response(conn, 201)["data"]
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.credit_path(conn, :credit), operation: @credit_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "transfer operation" do
    @transfer_attrs %{
      amount: 12.34,
      description: "salary",
      destination_account_id: nil,
      source_account_id: nil
    }

    @tag :logged_in
    test "creates a transfer operation when data is valid", %{
      conn: conn,
      bank_account: source
    } do
      destination = bank_account_fixture()

      Operations.create_financial_transaction(:credit, %{
        "amount" => 12.34,
        "destination_account_id" => source.id
      })

      conn =
        post(conn, Routes.transfer_path(conn, :transfer),
          operation: %{
            @transfer_attrs
            | destination_account_id: destination.id,
              source_account_id: source.id
          }
        )

      assert %{"id" => id, "description" => "salary"} = json_response(conn, 201)["data"]
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.credit_path(conn, :credit), operation: @transfer_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag :logged_in
    test "renders errors when source account does not have enough balance", %{
      conn: conn,
      bank_account: source
    } do
      destination = bank_account_fixture()

      conn =
        post(conn, Routes.transfer_path(conn, :transfer),
          operation: %{
            @transfer_attrs
            | destination_account_id: destination.id,
              source_account_id: source.id
          }
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
