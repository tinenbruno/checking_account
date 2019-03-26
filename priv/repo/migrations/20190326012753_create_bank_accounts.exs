defmodule CheckingAccount.Repo.Migrations.CreateBankAccounts do
  use Ecto.Migration

  def change do
    create table(:bank_accounts) do
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:bank_accounts, [:user_id])
  end
end
