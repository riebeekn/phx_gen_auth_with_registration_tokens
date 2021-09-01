defmodule RegTokensWeb.UserRegistrationController do
  use RegTokensWeb, :controller

  alias RegTokens.Accounts
  alias RegTokens.Accounts.User
  alias RegTokensWeb.UserAuth

  def new(conn, params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset, token: params["token"])
  end

  def create(conn, %{"token" => token, "user" => user_params}) do
    case Accounts.register_user_with_token(token, user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, token: token)
    end
  end
end
