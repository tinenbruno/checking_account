defmodule CheckingAccount.Operations.Adapters do
  alias CheckingAccount.Money

  def to_financial_transaction(%{"description" => description}, kind) do
    %{description: description, kind: kind}
  end

  def to_financial_transaction(%{}, kind) do
    %{kind: kind}
  end

  def to_accounting_entry(kind, params, currency \\ "BRL")

  def to_accounting_entry(
        %{"amount" => amount, "destination_account_id" => bank_account_id},
        :destination,
        currency
      ) do
    to_accounting_entry(amount, bank_account_id, currency)
  end

  def to_accounting_entry(
        %{"amount" => amount, "source_account_id" => bank_account_id},
        :source,
        currency
      ) do
    to_accounting_entry(-amount, bank_account_id, currency)
  end

  def to_accounting_entry(amount, bank_account_id, currency) do
    %{
      amount: amount |> Money.Adapters.to_money(),
      currency: currency,
      bank_account_id: bank_account_id
    }
  end
end
