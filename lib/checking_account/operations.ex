defmodule CheckingAccount.Operations do
  @moduledoc """
  The Operations context.
  """

  import Ecto.Query, warn: false
  alias CheckingAccount.Repo

  alias CheckingAccount.Operations.FinancialTransaction

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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking financial_transaction changes.

  ## Examples

      iex> change_financial_transaction(financial_transaction)
      %Ecto.Changeset{source: %FinancialTransaction{}}

  """
  def change_financial_transaction(%FinancialTransaction{} = financial_transaction) do
    FinancialTransaction.changeset(financial_transaction, %{})
  end
end