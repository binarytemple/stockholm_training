use Mix.Config

config :riak_core,
  node: 'dev2@127.0.0.1',
  web_port: 8298,
  handoff_port: 8299,
  ring_state_dir: 'data/dev/ring',
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
