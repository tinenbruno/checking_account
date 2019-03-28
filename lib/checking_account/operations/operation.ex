defmodule CheckingAccount.Operations.Operation do
  defstruct [:transaction, :source_entry, :destination_entry, :kind, :current_user]
end
