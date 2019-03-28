defmodule CheckingAccount.Operations.AccountingEntry do
  use Ecto.Schema
  import Ecto.Changeset

  alias CheckingAccount.Accounts.BankAccount
  alias CheckingAccount.Operations.FinancialTransaction

  @supported_currencies ~w(BRL)

  schema "accounting_entries" do
    field(:amount, :integer)
    field(:currency, :string)

    belongs_to(:bank_account, BankAccount)
    belongs_to(:financial_transaction, FinancialTransaction)

    timestamps()
  end

  @doc false
  def changeset(accounting_entry, attrs) do
    accounting_entry
    |> cast(attrs, [:amount, :currency, :bank_account_id, :financial_transaction_id])
    |> validate_required([:amount, :currency, :bank_account_id, :financial_transaction_id])
    |> foreign_key_constraint(:bank_account_id)
    |> foreign_key_constraint(:financial_transaction_id)
    |> validate_inclusion(:currency, @supported_currencies)
  end

  @doc false
  def credit_changeset(accounting_entry, attrs) do
    accounting_entry
    |> changeset(attrs)
    |> validate_number(:amount, greater_than: 0)
  end

  @doc false
  def debit_changeset(accounting_entry, attrs) do
    accounting_entry
    |> changeset(attrs)
    |> validate_number(:amount, less_than: 0)
  end
end
