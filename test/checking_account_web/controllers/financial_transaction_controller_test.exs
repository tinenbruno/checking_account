defmodule CheckingAccountWeb.FinancialTransactionControllerTest do
  use CheckingAccountWeb.ConnCase

  import CheckingAccount.Fixtures,
    only: [
      bank_account_fixture: 0
    ]

  @credit_attrs %{
    amount: 12.34,
    description: "salary",
    destination_account_id: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    bank_account = bank_account_fixture()
    {:ok, bank_account: bank_account}
  end

  describe "credit operation" do
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

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.credit_path(conn, :credit), operation: @credit_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
