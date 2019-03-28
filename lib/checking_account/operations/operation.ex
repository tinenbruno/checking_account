defmodule CheckingAccount.Operations.Operation do
  defstruct [:transaction, :source_entry, :destination_entry, :kind]
end
