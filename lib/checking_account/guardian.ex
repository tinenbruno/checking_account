defmodule CheckingAccount.Guardian do
  use Guardian, otp_app: :checking_account

  alias CheckingAccount.Accounts
  alias CheckingAccount.Accounts.User

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, id}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_token_subject}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    user = Accounts.get_user!(id)
    {:ok, user}
  end
end
