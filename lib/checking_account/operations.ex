defmodule CheckingAccount.Operations do
  @moduledoc """
  The Operations context.
  """

  import Ecto.Query, warn: false
  alias CheckingAccount.{Repo, Accounts}

  alias CheckingAccount.Operations.{
    FinancialTransaction,
    AccountingEntry,
    OperationManager,
    Adapters
  }

  @doc """
  Returns the list of financial_transactions.

  ## Examples

      iex> list_financial_transactions()
      [%FinancialTransaction{}, ...]

  """
  def list_financial_transactions do
    Repo.all(FinancialTransaction)
  end

  @doc """
  Gets a single financial_transaction.

  Raises `Ecto.NoResultsError` if the Financial transaction does not exist.

  ## Examples

      iex> get_financial_transaction!(123)
      %FinancialTransaction{}

      iex> get_financial_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_financial_transaction!(id), do: Repo.get!(FinancialTransaction, id)

  @doc """
  Creates a financial_transaction.

  ## Examples

      iex> create_financial_transaction(%{field: value})
      {:ok, %FinancialTransaction{}}

      iex> create_financial_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_financial_transaction(attrs \\ %{}) do
    %FinancialTransaction{}
    |> FinancialTransaction.changeset(attrs)
    |> Repo.insert()
  end

  def create_financial_transaction(:credit, attrs) do
    attrs
    |> Adapters.to_operation(:credit)
    |> OperationManager.insert_operation()
    |> Repo.transaction()
  end

  def create_financial_transaction(:transfer, attrs) do
    attrs
    |> Adapters.to_operation(:transfer)
    |> OperationManager.insert_operation()
    |> Repo.transaction()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking financial_transaction changes.

  ## Examples

      iex> change_financial_transaction(financial_transaction)
      %Ecto.Changeset{source: %FinancialTransaction{}}

  """
  def change_financial_transaction(%FinancialTransaction{} = financial_transaction) do
    FinancialTransaction.changeset(financial_transaction, %{})
  end

  @doc """
  Returns the list of accounting_entries.

  ## Examples

      iex> list_accounting_entries()
      [%AccountingEntry{}, ...]

  """
  def list_accounting_entries do
    Repo.all(AccountingEntry)
  end

  @doc """
  Gets a single accounting_entry.

  Raises `Ecto.NoResultsError` if the Accounting entry does not exist.

  ## Examples

      iex> get_accounting_entry!(123)
      %AccountingEntry{}

      iex> get_accounting_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_accounting_entry!(id), do: Repo.get!(AccountingEntry, id)

  @doc """
  Creates a accounting_entry.

  ## Examples

      iex> create_accounting_entry(%{field: value})
      {:ok, %AccountingEntry{}}

      iex> create_accounting_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_accounting_entry(attrs \\ %{}) do
    %AccountingEntry{}
    |> AccountingEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets the balance from an account as an integer. To show this info to the end
  user use the Money Adapter.
  """
  def get_balance(%{bank_account_id: account_id}) do
    try do
      Accounts.get_bank_account!(account_id)

      balance =
        from(e in AccountingEntry,
          where: [bank_account_id: ^account_id],
          select: sum(e.amount)
        )
        |> Repo.one() || 0

      {:ok, balance}
    rescue
      _ in Ecto.NoResultsError -> {:error, :account_not_found}
    end
  end

  def get_balance(%{}) do
    {:error, :account_not_found}
  end
end
