defmodule CheckingAccountWeb.FinancialTransactionController do
  use CheckingAccountWeb, :controller

  alias CheckingAccount.Operations
  alias CheckingAccount.Operations.FinancialTransaction

  action_fallback(CheckingAccountWeb.FallbackController)

  def credit(conn, %{"operation" => operation_params}) do
    operation_params =
      operation_params
      |> Map.put("current_user", conn.assigns[:current_user])

    with {:ok,
          %{
            financial_transaction: %FinancialTransaction{} = financial_transaction
          }} <- Operations.create_financial_transaction(:credit, operation_params) do
      conn
      |> put_status(:created)
      |> render("create.json",
        financial_transaction: financial_transaction
      )
    end
  end

  def transfer(conn, %{"operation" => operation_params}) do
    operation_params =
      operation_params
      |> Map.put("current_user", conn.assigns[:current_user])

    with {:ok,
          %{
            financial_transaction: %FinancialTransaction{} = financial_transaction
          }} <- Operations.create_financial_transaction(:transfer, operation_params) do
      conn
      |> put_status(:created)
      |> render("create.json",
        financial_transaction: financial_transaction
      )
    end
  end

  def balance(conn, %{"bank_account_id" => bank_account_id}) do
    with {:ok, balance} <-
           Operations.get_balance(%{
             bank_account_id: bank_account_id,
             current_user: conn.assigns[:current_user]
           }) do
      conn
      |> put_status(:ok)
      |> render("balance.json", balance: balance)
    end
  end
end
