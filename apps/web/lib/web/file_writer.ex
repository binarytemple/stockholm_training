defmodule Web.FileWriter do
  @moduledoc false

  defstruct [:file]

  @type t :: %__MODULE__{
          file: File.io_device()
        }

  @type name :: String.t()

  ## API

  @spec new(name) :: t
  def new(name) do
    path = path(name)
    path |> Path.dirname() |> File.mkdir_p!()
    file = File.open!(path, [:write, :binary])
    %__MODULE__{file: file}
  end

  @spec write_chunk(t, chunk :: binary) :: :ok
  def write_chunk(handler, chunk) when is_binary(chunk) do
    :ok = IO.binwrite(handler.file, chunk)
  end

  @spec close(t) :: :ok
  def close(handler) do
    :ok = File.close(handler.file)
  end

  ## Helpers

  @spec path(name) :: Path.t()
  defp path(name) do
    Application.fetch_env!(:web, :uploads_dir)
    |> Path.join(name)
  end
end
