use Mix.Config
 config :riak_core,
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

import_config "#{Mix.env}.exs"
