use Mix.Config

config :web,
  port: 8080,
  uploads_dir: "uploads",
  download_chunk_size: 5000

config :lager,
  colored: true,
  error_logger_hwm: 5000,
  log_root: 'data/dev/log',
  crash_log: 'crash.log',
  handlers: [
     lager_console_backend: :info,
     lager_file_backend: [file: 'error.log', level: :error],
     lager_file_backend: [file: 'console.log', level: :info]
  ]
