defmodule CheckingAccount.Repo do
  use Ecto.Repo,
    otp_app: :checking_account,
    adapter: Ecto.Adapters.Postgres
end
