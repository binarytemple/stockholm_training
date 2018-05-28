defmodule Web.Router do
  @moduledoc false

  use Raxx.Server

  use Raxx.Router, [
    {%{method: :PUT, path: ["uploads", _name]}, Web.UploadService},
    {%{method: :GET, path: ["uploads", _name]}, Web.DownloadService},
    {_, Web.NotFound}
  ]
end
