defmodule OtelSample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    OpentelemetryPhoenix.setup()
    OpentelemetryEcto.setup([:otel_sample, :repo])

    children = [
      OtelSampleWeb.Telemetry,
      OtelSample.Repo,
      {DNSCluster, query: Application.get_env(:otel_sample, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OtelSample.PubSub},
      # Start a worker by calling: OtelSample.Worker.start_link(arg)
      # {OtelSample.Worker, arg},
      # Start to serve requests, typically the last entry
      OtelSampleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OtelSample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OtelSampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
