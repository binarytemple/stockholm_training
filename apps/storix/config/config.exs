use Mix.Config
config :riak_core,
  ring_state_dir: 'ring_data_dir',
  handoff_port: 8099,
  handoff_ip: '127.0.0.1',
  schema_dirs: ['priv'],
  ring_creation_size: 16,
  vnode_inactivity_timeout: 10000

config :lager,
  colored: true,
  error_logger_hwm: 5000

config :logger,
  backends: [LoggerLagerBackend],
  handle_otp_reports: false,
  level: :debug

config :sasl,
  errlog_type: :error

config :storix,
  port: 8080,
  uploads_dir: "uploads",
  download_chunk_size: 5000

import_config "#{Mix.env}.exs"
