defmodule CheckingAccount.AccountsTest do
  use CheckingAccount.DataCase

  import CheckingAccount.Fixtures, only: [user_fixture: 0, bank_account_fixture: 0]
  alias CheckingAccount.Accounts

  describe "users" do
    alias CheckingAccount.Accounts.User

    @valid_attrs %{name: "some name", password: "some password", username: "some username"}
    @update_attrs %{
      name: "some updated name",
      password: "some updated password",
      username: "some updated username"
    }
    @invalid_attrs %{name: nil, password: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "some name"
      assert Argon2.check_pass(user.password_hash, "some password_hash")
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.name == "some updated name"
      assert Argon2.check_pass(user.password_hash, "some password_hash")
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "login_by_username_and_password logins a user" do
      user_fixture()

      assert {:ok, token, claims} =
               Accounts.login_by_username_and_password("some username", "some password")
    end

    test "login_by_username_and_password returns error when wrong password" do
      user_fixture()

      assert {:error, :unauthorized} =
               Accounts.login_by_username_and_password("some username", "wrong")
    end

    test "login_by_username_and_password returns error when wrong user" do
      user_fixture()

      assert {:error, :not_found} = Accounts.login_by_username_and_password("wrong", "wrong")
    end
  end

  describe "bank_accounts" do
    alias CheckingAccount.Accounts.BankAccount

    @invalid_attrs %{}

    test "list_bank_accounts/0 returns all bank_accounts" do
      bank_account = bank_account_fixture()
      assert Accounts.list_bank_accounts() == [bank_account]
    end

    test "get_bank_account!/1 returns the bank_account with given id" do
      bank_account = bank_account_fixture()
      assert Accounts.get_bank_account!(bank_account.id) == bank_account
    end

    test "create_bank_account/1 with valid data creates a bank_account" do
      user = user_fixture()

      assert {:ok, %BankAccount{} = bank_account} =
               Accounts.create_bank_account(%{user_id: user.id})
    end

    test "create_bank_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_bank_account(@invalid_attrs)
    end

    test "delete_bank_account/1 deletes the bank_account" do
      bank_account = bank_account_fixture()
      assert {:ok, %BankAccount{}} = Accounts.delete_bank_account(bank_account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_bank_account!(bank_account.id) end
    end

    test "change_bank_account/1 returns a bank_account changeset" do
      bank_account = bank_account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_bank_account(bank_account)
    end
  end
end
