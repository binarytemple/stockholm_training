defmodule Upload.Router do
  @moduledoc false

  use Raxx.Server

  use Raxx.Router, [
    {%{method: :PUT, path: ["uploads", _name]}, Upload.UploadService},
    {%{method: :GET, path: ["uploads", _name]}, Upload.DownloadService},
    {_, Upload.NotFound}
  ]
end
