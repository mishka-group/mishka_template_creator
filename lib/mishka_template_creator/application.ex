defmodule MishkaTemplateCreator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MishkaTemplateCreatorWeb.Telemetry,
      # Start the Ecto repository
      MishkaTemplateCreator.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: MishkaTemplateCreator.PubSub},
      # Start Finch
      {Finch, name: MishkaTemplateCreator.Finch},
      # Start the Endpoint (http/https)
      MishkaTemplateCreatorWeb.Endpoint
      # Start a worker by calling: MishkaTemplateCreator.Worker.start_link(arg)
      # {MishkaTemplateCreator.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MishkaTemplateCreator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MishkaTemplateCreatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
