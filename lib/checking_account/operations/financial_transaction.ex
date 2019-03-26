defmodule CheckingAccount.Operations.FinancialTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_kinds ~w(debit, credit, transfer)

  schema "financial_transactions" do
    field(:kind, :string)
    field(:description, :string)

    timestamps()
  end

  @doc false
  def changeset(financial_transaction, attrs) do
    financial_transaction
    |> cast(attrs, [:kind, :description])
    |> validate_required([:kind])
    |> validate_inclusion(:kind, @valid_kinds)
  end
end
