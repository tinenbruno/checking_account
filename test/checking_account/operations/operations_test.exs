defmodule CheckingAccount.OperationsTest do
  use CheckingAccount.DataCase

  alias CheckingAccount.Operations

  describe "financial_transactions" do
    alias CheckingAccount.Operations.FinancialTransaction

    @valid_attrs %{kind: "transfer"}
    @invalid_attrs %{kind: "unknown"}

    def financial_transaction_fixture(attrs \\ %{}) do
      {:ok, financial_transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Operations.create_financial_transaction()

      financial_transaction
    end

    test "list_financial_transactions/0 returns all financial_transactions" do
      financial_transaction = financial_transaction_fixture()
      assert Operations.list_financial_transactions() == [financial_transaction]
    end

    test "get_financial_transaction!/1 returns the financial_transaction with given id" do
      financial_transaction = financial_transaction_fixture()

      assert Operations.get_financial_transaction!(financial_transaction.id) ==
               financial_transaction
    end

    test "create_financial_transaction/1 with valid data creates a financial_transaction" do
      assert {:ok, %FinancialTransaction{} = financial_transaction} =
               Operations.create_financial_transaction(@valid_attrs)

      assert financial_transaction.kind == "transfer"
    end

    test "create_financial_transaction/1 with invalid kind returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operations.create_financial_transaction(@invalid_attrs)
    end

    test "change_financial_transaction/1 returns a financial_transaction changeset" do
      financial_transaction = financial_transaction_fixture()
      assert %Ecto.Changeset{} = Operations.change_financial_transaction(financial_transaction)
    end
  end
end
