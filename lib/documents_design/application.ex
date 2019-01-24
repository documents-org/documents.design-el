defmodule DocumentsDesign.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      DocumentsDesign.Repo,
      # Start the endpoint when the application starts
      DocumentsDesignWeb.Endpoint
      # Starts a worker by calling: DocumentsDesign.Worker.start_link(arg)
      # {DocumentsDesign.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DocumentsDesign.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DocumentsDesignWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
