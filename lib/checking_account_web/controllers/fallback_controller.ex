defmodule CheckingAccountWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CheckingAccountWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CheckingAccountWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, _, %Ecto.Changeset{} = changeset, _}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CheckingAccountWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :balance, :insufficient_balance, _}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CheckingAccountWeb.ErrorView)
    |> render("error_message.json", message: "Insufficient balance on source account")
  end

  def call(conn, {:error, :is_user_account, :account_not_found, _}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CheckingAccountWeb.ErrorView)
    |> render("error_message.json", message: "Account not found")
  end

  def call(conn, {:error, :account_not_found}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CheckingAccountWeb.ErrorView)
    |> render("error_message.json", message: "Account not found")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(CheckingAccountWeb.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(CheckingAccountWeb.ErrorView)
    |> render(:"404")
  end
end
