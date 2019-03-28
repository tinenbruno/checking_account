defmodule CheckingAccountWeb.AuthenticationPlug do
  import Plug.Conn

  alias CheckingAccount.Guardian
  use CheckingAccountWeb, :controller

  def init(_opts) do
  end

  def call(conn, _opts) do
    headers = get_req_header(conn, "authorization")

    with {:ok, token} <- fetch_token_from_headers(headers),
         {:ok, claims} <- Guardian.decode_and_verify(token),
         {:ok, user} <- Guardian.resource_from_claims(claims) do
      conn
      |> assign(:current_user, user)
    else
      {:error, :authorization_not_found} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(CheckingAccountWeb.ErrorView)
        |> render(:"401")
        |> halt()

      {:error, _} ->
        conn
        |> put_status(:invalid)
        |> put_view(CheckingAccountWeb.ErrorView)
        |> render(:"400")
        |> halt()
    end
  end

  defp fetch_token_from_headers([]), do: {:error, :authorization_not_found}

  defp fetch_token_from_headers([value | tail]) do
    case value |> String.trim() do
      "Bearer " <> token ->
        {:ok, token}

      _ ->
        fetch_token_from_headers(tail)
    end
  end
end
