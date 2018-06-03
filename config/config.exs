use Mix.Config
alias :erlang, as: E

config :lager,
  colored: true,
  error_logger_hwm: 5000

config :logger,
  backends: [LoggerLagerBackend],
  handle_otp_reports: false,
  level: :debug

config :riak_core,
  node: :erlang.node(),
  schema_dirs: ['priv'],
  ring_creation_size: 16,
  vnode_inactivity_timeout: 10000

config :sasl,
  errlog_type: :error

config :setup,
  log_dir: E.binary_to_list("data/#{E.atom_to_binary(Mix.env,:utf8)}/logs"),
  data_dir: E.binary_to_list("data/#{E.atom_to_binary(Mix.env,:utf8)}/data")

import_config "#{Mix.env}.exs"
