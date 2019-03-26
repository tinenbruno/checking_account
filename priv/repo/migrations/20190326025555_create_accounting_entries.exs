defmodule CheckingAccount.Repo.Migrations.CreateAccountingEntries do
  use Ecto.Migration

  def change do
    create table(:accounting_entries) do
      add :amount, :integer
      add :currency, :string, size: 3
      add :bank_account_id, references(:bank_accounts, on_delete: :nothing)
      add :financial_transaction_id, references(:financial_transactions, on_delete: :nothing)

      timestamps()
    end

    create index(:accounting_entries, [:bank_account_id])
    create index(:accounting_entries, [:financial_transaction_id])
  end
end
