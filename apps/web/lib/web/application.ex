defmodule Web.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = Application.fetch_env!(:web, :port)

    children = [
      {Ace.HTTP.Service, [{Web.Router, []}, [port: port, cleartext: true]]}
    ]

    opts = [strategy: :one_for_one, name: Web.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
