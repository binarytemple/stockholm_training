defmodule Storix do
  use Application
  require Logger
  alias :erlang, as: E

  def start(_type, _args) do

    unless Mix.env == :prod do
      Logger.debug("setting the nodename")
      nodename = E.list_to_atom( E.atom_to_list( Mix.env ) ++ '@127.0.0.1' )
      :net_kernel.start([nodename, :longnames])
    end

    Application.ensure_all_started(:riak_core)

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
