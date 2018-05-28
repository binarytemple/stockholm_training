defmodule Upload.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = Application.fetch_env!(:upload, :port)

    children = [
      {Ace.HTTP.Service, [{Upload.Router, []}, [port: port, cleartext: true]]}
    ]

    opts = [strategy: :one_for_one, name: Upload.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
