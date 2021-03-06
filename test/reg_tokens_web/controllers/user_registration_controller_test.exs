defmodule RegTokensWeb.UserRegistrationControllerTest do
  use RegTokensWeb.ConnCase, async: true

  import RegTokens.AccountsFixtures

  @default_registration_token "12375rlRQK7FZ13HBJDZNrJvo0nRBM3eUL1HbuEao8E"

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new, @default_registration_token))
      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "Log in</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn =
        conn
        |> log_in_user(user_fixture())
        |> get(Routes.user_registration_path(conn, :new, @default_registration_token))

      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()
      token = registration_token_fixture().token_string

      conn =
        post(conn, Routes.user_registration_path(conn, :create, token), %{
          "user" => valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create, @default_registration_token), %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
      assert response =~ "Invalid registration token!"
    end
  end
end
