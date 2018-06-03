use Mix.Config

config :web,
  port: 8080,
  uploads_dir: "uploads",
  download_chunk_size: 5000


config :riak_core,
  web_port: 8098,
  handoff_port: 8099,
  ring_state_dir: 'data/dev/data',
  platform_data_dir: 'data/dev/data'

config :lager,
  colored: true,
  error_logger_hwm: 5000,
  log_root: 'data/dev/log',
  crash_log: 'crash.log',
  level: :debug,
  handlers: [
     lager_console_backend: :info,
     lager_file_backend: [file: 'error.log', level: :error],
     lager_file_backend: [file: 'console.log', level: :info]
  ]
