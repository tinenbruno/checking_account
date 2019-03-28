defmodule CheckingAccountWeb.FinancialTransactionView do
  use CheckingAccountWeb, :view
  alias CheckingAccountWeb.FinancialTransactionView
  alias CheckingAccount.Money.Adapters

  def render("create.json", %{financial_transaction: transaction}) do
    %{
      data: render_one(transaction, FinancialTransactionView, "financial_transaction.json")
    }
  end

  def render("financial_transaction.json", %{financial_transaction: financial_transaction}) do
    %{id: financial_transaction.id, description: financial_transaction.description}
  end

  def render("balance.json", %{balance: balance}) do
    %{
      data: %{
        balance: balance |> Adapters.from_money()
      }
    }
  end
end
