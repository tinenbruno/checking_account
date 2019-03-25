defmodule CheckingAccount.AccountsTest do
  use CheckingAccount.DataCase

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

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      %{user | password: nil}
    end

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
end
