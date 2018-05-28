defmodule Imageer do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      # supervisor(Imageer.Repo, []),
      # Start the endpoint when the application starts
      worker(Ace.HTTP.Service, [{Imageer.Router, []}, [port: 8080, cleartext: true]])
      # Start your own worker by calling: Imageer.Worker.start_link(arg1, arg2, arg3)
      # worker(Imageer.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Imageer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
