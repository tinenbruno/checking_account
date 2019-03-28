defmodule CheckingAccount.Operations.Adapters do
  alias CheckingAccount.Money

  alias CheckingAccount.Operations.Operation

  def to_operation(attrs, :credit) do
    %Operation{
      transaction: attrs |> to_financial_transaction("credit"),
      destination_entry: attrs |> to_accounting_entry(:destination),
      current_user: attrs["current_user"],
      kind: :credit
    }
  end

  def to_operation(attrs, :transfer) do
    %Operation{
      transaction: attrs |> to_financial_transaction("transfer"),
      source_entry: attrs |> to_accounting_entry(:source),
      destination_entry: attrs |> to_accounting_entry(:destination),
      current_user: attrs["current_user"],
      kind: :transfer
    }
  end

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
