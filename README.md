# CheckingAccount

A checking account REST API, where you can manage `users`, `bank_accounts` and `transactions`.

## Overview

The checking account is a transaction based bank account. Each transaction generates entries in the corresponding account which represent the history of operations under that account.

Currently it supports via API:
  * `user` creation: `POST /api/users` (`PUBLIC`)
  ```
  Expected payload:
  {
      "user": {
          "name": "bruno",
          "username": "bt",
          "password": "123456"
      }
  }
  ```
  * `user` login: `POST /api/users/login` (`PUBLIC`)
  ```
  Expected payload:
  {
      "username": "username",
      "password": "123456"
  }
  ```
  * `credit` operation: `POST /api/operations/credit` (`PRIVATE`)
  ```
  Expected payload:
  {
      "operation": {
          "amount": 100.12,
          "destination_account_id": 1,
          "description": "salary"
      }
  }
  ```

  * `transfer` operation: `POST /api/operations/transfer` (`PRIVATE`)
  ```
  Expected payload:
  {
      "operation": {
          "amount": 1.23,
          "source_account_id": 1,
          "destination_account_id": 2,
          "description": "money to friend"
      }
  }
  ```
  * `balance` operation: `GET /api/balance` (`PRIVATE`)
  ```
  Expected query string: ?bank_account_id=3
  ```

The login endpoint generates a `Bearer` token that should be passed as an authorization header to the calls of the private endpoints.

The bank account creation for a user still needs to be done manually in the console. This can be done using:

```
iex> CheckingAccount.Accounts.create_bank_account(%{user_id: user_id})
```

## Running Locally

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Running Tests

To run tests use: `mix test`

## Contributing

Issues and pull requests are welcome. Feel free to fork this repository, make changes and send pull requests. I will be review and eventually merge them in the codebase.

## License

[GNU General Public License v3.0](./LICENSE)
