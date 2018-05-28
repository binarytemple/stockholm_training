defmodule Storix do
  use Application
  require Logger

  def start(_type, _args) do

    case Storix.Supervisor.start_link do
      {:ok, pid} ->
        :ok = :riak_core.register(vnode_module: Storix.VNode)
        :ok = :riak_core_node_watcher.service_up(Storix.Service, self())
        {:ok, pid}
      {:error, reason} ->
        Logger.error("Unable to start Storix supervisor because: #{inspect reason}")
    end
  end

end
