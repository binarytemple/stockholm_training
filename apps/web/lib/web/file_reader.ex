defmodule Web.FileReader do
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

    case File.open(path, [:read]) do
      {:ok, file} ->
        {:ok, %__MODULE__{file: file}}

      {:error, _} = err ->
        err
    end
  end

  @spec read_chunk(t) :: {t, binary()} | :eof
  def read_chunk(handler) do
    chunk_size = Application.fetch_env!(:web, :download_chunk_size)

    case IO.binread(handler.file, chunk_size) do
      {:error, _} = err ->
        raise "Failed to read file: #{inspect(err)}"

      :eof ->
        :eof

      data ->
        {handler, data}
    end
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
