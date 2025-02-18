defmodule Agora.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AgoraWeb.Telemetry,
      Agora.Repo,
      {DNSCluster, query: Application.get_env(:agora, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Agora.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Agora.Finch},
      # Start a worker by calling: Agora.Worker.start_link(arg)
      # {Agora.Worker, arg},
      # Start to serve requests, typically the last entry
      AgoraWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Agora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AgoraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
