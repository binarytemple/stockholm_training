defmodule Storix.Supervisor do
  use Supervisor

  def start_link do
    # riak_core appends _sup to the application name.
    Supervisor.start_link(__MODULE__, [], [name: :storix_sup])
  end

  def init(args) do

    children = [
      supervisor(Storix.WriteFsmSupervisor, []),
      supervisor(Storix.GetFsmSupervisor, []),
      supervisor(Storix.CoverageFsmSupervisor, []),
      worker(:riak_core_vnode_master, [Storix.VNode], id: NoSlides.VNode_master_worker)
    ]
    supervise(children, strategy: :one_for_one, max_restarts: 5, max_seconds: 10)
  end

end
