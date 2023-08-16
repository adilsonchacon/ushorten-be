defmodule Ushorten.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      UshortenWeb.Telemetry,
      # Start the Ecto repository
      Ushorten.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ushorten.PubSub},
      # Start Finch
      {Finch, name: Ushorten.Finch},
      # Start the Endpoint (http/https)
      UshortenWeb.Endpoint
      # Start a worker by calling: Ushorten.Worker.start_link(arg)
      # {Ushorten.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ushorten.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UshortenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
