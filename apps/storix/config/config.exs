use Mix.Config

 config :riak_core,
  nodename: :erlang.node(),
  schema_dirs: ['priv'],
  ring_creation_size: 16,
  vnode_inactivity_timeout: 10000

 config :sasl,
   errlog_type: :error

import_config "#{Mix.env}.exs"
