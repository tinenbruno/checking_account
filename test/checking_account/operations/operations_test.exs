defmodule CheckingAccount.OperationsTest do
  use CheckingAccount.DataCase

  import CheckingAccount.Fixtures,
    only: [
      user_fixture: 0,
      bank_account_fixture: 0,
      financial_transaction_fixture: 0,
      accounting_entry_fixture: 0
    ]

  alias CheckingAccount.Operations
  alias CheckingAccount.Repo

  describe "financial_transactions" do
    alias CheckingAccount.Operations.FinancialTransaction

    @valid_attrs %{kind: "transfer"}
    @invalid_attrs %{kind: "unknown"}

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

  describe "accounting_entries" do
    alias CheckingAccount.Operations.AccountingEntry

    @valid_attrs %{amount: "1205", currency: "BRL"}
    @invalid_attrs %{amount: "111", currency: "ABC"}

    test "list_accounting_entries/0 returns all accounting_entries" do
      accounting_entry = accounting_entry_fixture()
      assert Operations.list_accounting_entries() == [accounting_entry]
    end

    test "get_accounting_entry!/1 returns the accounting_entry with given id" do
      accounting_entry = accounting_entry_fixture()
      assert Operations.get_accounting_entry!(accounting_entry.id) == accounting_entry
    end

    test "create_accounting_entry/1 with valid data creates a accounting_entry" do
      transaction = financial_transaction_fixture()
      bank_account = bank_account_fixture()

      assert {:ok, %AccountingEntry{} = accounting_entry} =
               Operations.create_accounting_entry(
                 @valid_attrs
                 |> Map.merge(%{
                   bank_account_id: bank_account.id,
                   financial_transaction_id: transaction.id
                 })
               )

      assert accounting_entry.amount == 1205
      assert accounting_entry.currency == "BRL"
    end

    test "create_accounting_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operations.create_accounting_entry(@invalid_attrs)
    end
  end

  describe "balance" do
    test "returns balance if account has entries" do
      bank_account = bank_account_fixture() |> Repo.preload(:user)

      Operations.create_financial_transaction(:credit, %{
        "amount" => 12.34,
        "destination_account_id" => bank_account.id,
        "current_user" => bank_account.user
      })

      assert Operations.get_balance(%{
               bank_account_id: bank_account.id,
               current_user: bank_account.user
             }) == {:ok, 1234}
    end

    test "returns 0 if account has no entries" do
      bank_account = bank_account_fixture() |> Repo.preload(:user)

      assert Operations.get_balance(%{
               bank_account_id: bank_account.id,
               current_user: bank_account.user
             }) == {:ok, 0}
    end

    test "returns error if account not found" do
      bank_account = bank_account_fixture() |> Repo.preload(:user)

      assert Operations.get_balance(%{bank_account_id: 12345, current_user: bank_account.user}) ==
               {:error, :account_not_found}
    end

    test "returns error if account is not from user" do
      bank_account = bank_account_fixture() |> Repo.preload(:user)
      user = user_fixture()

      assert Operations.get_balance(%{bank_account_id: bank_account.id, current_user: user}) ==
               {:error, :account_not_found}
    end
  end
end
