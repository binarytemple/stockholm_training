defmodule Web.Chunker do
  use GenStateMachine
  import Logger
  alias __MODULE__

  defmodule State do
    import Logger

    @enforce_keys [:id, :chunk_size]
    defstruct [:id, :chunk_size, callback: &State.example_callback/2, acc: "", counter: 0]

    def example_callback(data, %State{acc: acc} = state) when is_binary(acc) do
      msg = ~s"""
      -dumping-
      id        : #{inspect(state.id)}
      counter   : #{state.counter}
      chunk_size: #{state.chunk_size}
      data      : #{inspect(data)}
      acc_size  : #{:erlang.size(acc)}
      acc       : #{inspect(acc)}
      """

      Logger.warn(msg)
    end
  end

  # def create(id, chunk_size) do
  #   {:ok, pid} =
  #     GenStateMachine.start_link(
  #       Chunker,
  #       {:s_default, %State{id: id, chunk_size: chunk_size}}
  #     )

  #   pid
  # end

  def create(id, chunk_size, callback) do
    {:ok, pid} =
      GenStateMachine.start_link(
        Chunker,
        {:s_default, %State{id: id, chunk_size: chunk_size, callback: callback}}
      )

    pid
  end

  def get_state(pid) do
    :sys.get_state(pid)
  end

  def send_data(pid, data = <<_::binary>>) do
    GenStateMachine.cast(pid, {:input, data})
  end

  def flush_and_terminate(pid) do
    Process.flag(:trap_exit, true)
    GenStateMachine.call(pid, :flush_and_terminate)
    receive do
      {:EXIT, ^pid, :normal} ->
        info("received successful exit")
        :ok
      {:EXIT, ^pid, _} =
        res ->
        error("received failed exit #{inspect(res)}")
        :fail
    end
  end

  # # Callbacks

  def handle_event(
        {:call, from},
        :flush_and_terminate,
        :s_default,
        state
      ) do
    # because of the way that handle_event {:input,data} trims the
    # buffer by means of the return:
    # {:next_state, :s_default, new_state, [{:next_event, :cast, {:input, ""}}]}
    # we know that whatever is in the state.acc is less than the chunk size so can be
    # safely passed to the callback, then terminate this fsm
    state.callback.(state.acc, state)
    {:stop_and_reply, :normal, {:reply, from, :ok}}
  end

  def handle_event(
        :cast,
        {:input, data},
        :s_default,
        state = %State{
          chunk_size: chunk_size
        }
      )
      when is_binary(data) do
    chunk = state.acc <> data

    case chunk do
      <<head::binary-size(chunk_size), rest::binary>> ->
        new_state =
          state
          |> Map.put(:acc, rest)
          |> Map.update(:counter, 0, &(&1 + 1))

        state.callback.(head, new_state)

        case :erlang.size(rest) do
          size when size <= chunk_size ->
            {:next_state, :s_default, new_state}

          _ ->
            {:next_state, :s_default, new_state, [{:next_event, :cast, {:input, ""}}]}
        end

      _ ->
        new_state =
          state
          |> Map.put(:acc, chunk)
          |> Map.update(:counter, 0, &(&1 + 1))

        {:next_state, :s_default, new_state}
    end
  end
end
