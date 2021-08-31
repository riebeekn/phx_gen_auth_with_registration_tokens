defmodule RegTokens.Repo do
  use Ecto.Repo,
    otp_app: :reg_tokens,
    adapter: Ecto.Adapters.Postgres
end
