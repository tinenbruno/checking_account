defmodule CheckingAccount.Operations.OperationManager do
  alias Ecto.Multi

  alias CheckingAccount.Operations

  alias CheckingAccount.Operations.{
    FinancialTransaction,
    AccountingEntry,
    Operation
  }

  def insert_operation(%Operation{
        transaction: transaction_attrs,
        destination_entry: destination_entry_attrs,
        kind: :credit
      }) do
    Multi.new()
    |> insert_financial_transaction(transaction_attrs)
    |> insert_entry(:credit, destination_entry_attrs, :credit_accounting_entry)
  end

  def insert_operation(%Operation{
        kind: :transfer,
        transaction: transaction_attrs,
        destination_entry: destination_entry_attrs,
        source_entry: source_entry_attrs
      }) do
    Multi.new()
    |> validate_source_account_balance(source_entry_attrs)
    |> insert_financial_transaction(transaction_attrs)
    |> insert_entry(:credit, destination_entry_attrs, :credit_accounting_entry)
    |> insert_entry(:debit, source_entry_attrs, :debit_accounting_entry)
  end

  defp insert_financial_transaction(multi, transaction_attrs) do
    multi
    |> Multi.insert(
      :financial_transaction,
      FinancialTransaction.changeset(%FinancialTransaction{}, transaction_attrs)
    )
  end

  defp insert_entry(multi, kind, entry_attrs, name) do
    multi
    |> Multi.insert(name, fn %{financial_transaction: financial_transaction} ->
      create_entry_changeset(kind, entry_attrs, financial_transaction)
    end)
  end

  defp validate_source_account_balance(multi, %{amount: amount} = source_entry_attrs) do
    multi
    |> Multi.run(:balance, fn _, _ ->
      {:ok, balance} = Operations.get_balance(source_entry_attrs)

      if balance < -amount do
        {:error, :insufficient_balance}
      else
        {:ok, balance}
      end
    end)
  end

  defp create_entry_changeset(:credit, entry_params, financial_transaction) do
    %AccountingEntry{financial_transaction_id: financial_transaction.id}
    |> AccountingEntry.credit_changeset(entry_params)
  end

  defp create_entry_changeset(:debit, entry_params, financial_transaction) do
    %AccountingEntry{financial_transaction_id: financial_transaction.id}
    |> AccountingEntry.debit_changeset(entry_params)
  end
end
