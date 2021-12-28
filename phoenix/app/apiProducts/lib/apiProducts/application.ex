defmodule ApiProducts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ApiProducts.Repo,
      # Start the Telemetry supervisor
      ApiProductsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ApiProducts.PubSub},
      # Start the Endpoint (http/https)
      ApiProductsWeb.Endpoint, 

      {Redix, {"redis://localhost:6379", [name: :redis_server]}}
      # Start a worker by calling: ApiProducts.Worker.start_link(arg)
      # {ApiProducts.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ApiProducts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ApiProductsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
