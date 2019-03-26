defmodule CheckingAccount.Repo.Migrations.CreateFinancialTransactions do
  use Ecto.Migration

  def change do
    create table(:financial_transactions) do
      add :kind, :string
      add :description, :string

      timestamps()
    end

  end
end
