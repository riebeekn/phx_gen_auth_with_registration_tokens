defmodule RegTokens.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      RegTokens.Repo,
      # Start the Telemetry supervisor
      RegTokensWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RegTokens.PubSub},
      # Start the Endpoint (http/https)
      RegTokensWeb.Endpoint
      # Start a worker by calling: RegTokens.Worker.start_link(arg)
      # {RegTokens.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RegTokens.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RegTokensWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
