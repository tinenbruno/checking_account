defmodule CheckingAccount.Operations.OperationManager do
  import Ecto.Query, warn: false
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
      AccountingEntry.credit_changeset(
        %AccountingEntry{financial_transaction_id: financial_transaction.id},
        destination_entry_attrs
      )
    end)
  end

  def insert_operation(transaction_attrs, destination_entry_attrs, source_entry_attrs) do
    insert_operation(transaction_attrs, destination_entry_attrs)
    |> Multi.run(:balance, fn repo, _ ->
      balance =
        from(e in AccountingEntry,
          where: [bank_account_id: ^source_entry_attrs[:bank_account_id]],
          select: sum(e.amount)
        )
        |> repo.one || 0

      if balance < -source_entry_attrs[:amount] do
        {:error, :insufficient_balance}
      else
        {:ok, balance}
      end
    end)
    |> Multi.insert(:source_accounting_entry, fn %{financial_transaction: financial_transaction} ->
      AccountingEntry.debit_changeset(
        %AccountingEntry{financial_transaction_id: financial_transaction.id},
        source_entry_attrs
      )
    end)
  end
end
