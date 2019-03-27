defmodule CheckingAccount.Operations.OperationManager do
  alias Ecto.Multi

  alias CheckingAccount.Operations.{
    FinancialTransaction,
    AccountingEntry
  }

  def insert_operation(transaction_attrs, destination_entry_attrs, source_entry_attrs \\ nil)

  def insert_operation(transaction_attrs, destination_entry_attrs, nil) do
    Multi.new()
    |> Multi.insert(
      :financial_transaction,
      FinancialTransaction.changeset(%FinancialTransaction{}, transaction_attrs)
    )
    |> Multi.insert(:accounting_entry, fn %{financial_transaction: financial_transaction} ->
      AccountingEntry.changeset(
        %AccountingEntry{financial_transaction_id: financial_transaction.id},
        destination_entry_attrs
      )
    end)
  end

  def insert_operation(transaction_attrs, destination_entry_attrs, source_entry_attrs) do
    insert_operation(transaction_attrs, destination_entry_attrs)
    |> Multi.insert(:accounting_entry, fn %{financial_transaction: financial_transaction} ->
      AccountingEntry.changeset(
        %AccountingEntry{financial_transaction_id: financial_transaction.id},
        source_entry_attrs
      )
    end)
  end
end
