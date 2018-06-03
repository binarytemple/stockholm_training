defmodule Storix.LeveledBackend do
  require Logger

# -include_lib("leveled/include/leveled.hrl").

# -record(state, {bookie, base_path}).

# require Record
# Record.defrecord :state, bookie: nil , base_path: ""

# https://github.com/martinsumner/leveled/blob/master/include/leveled.hrl
# @riak_tag :_rkv
@std_tag :o
# @idx_tag :i
# @head_tag :h
# @inkt_stnd :stnd
# @inkt_mput :mput
# @inkt_keyd :keyd
# @inkt_tomb :tomb
# @cache_type :skpl

@typedoc """
      Type that represents Examples struct with :first as integer and :last as integer.
 """
@type state :: %{bookie: any(), base_path: list() }

def new( opts=%{path: path} ) when is_binary(path) do
    new(%{opts| path: :erlang.binary_to_list(path) })
end

def new( _opts=%{path: path} ) when is_list(path) do
    ledger_cache_size =  2000
    journal_size = 500000000
    sync_strategy = :none
    {:ok, bookie} = :leveled_bookie.book_start(path, ledger_cache_size,
                                             journal_size, sync_strategy)
    state = %{bookie: bookie, base_path: path}
    {:ok, state}
end

def put(state=%{bookie: bookie}, bucket, key, value) do
  r = :leveled_bookie.book_put(bookie, bucket, key, value, [])
  {r, state}
end

def get(state=%{bookie: bookie}, bucket, key) do
     k = {bucket, key}
     res = case :leveled_bookie.book_get(bookie, bucket, key) do
               :not_found -> {:not_found, k};
               {:ok, value} -> {:found, {k, value}}
           end
     {res, state}
end

def delete(state=%{bookie: bookie}, bucket, key)  do
  r = :leveled_bookie.book_delete(bookie, bucket, key, [])
  {r, state}
end

def keys(state=%{bookie: bookie}, bucket) do
     fold_heads_fun = fn(_b, k, _proxy_v, acc) -> [k | acc] end
     {:async, fold_fn} = :leveled_bookie.book_returnfolder(bookie,
                             {:foldheads_bybucket,
                                 @std_tag,
                                 bucket,
                                 :all,
                                 fold_heads_fun,
                                 true, true, false})
     keys = fold_fn.()
     {keys, state}
end

def is_empty(state=%{bookie: bookie}) do
     fold_buckets_fun = fn(b, acc) -> [b | acc] end
     {:async, fold_fn} = :leveled_bookie.book_returnfolder(bookie,
                                                        {:binary_bucketlist,
                                                         @std_tag,
                                                         {fold_buckets_fun, []}})
     is_empty = case fold_fn.() do
                   [] -> true;
                   _ -> false
               end
     {is_empty, state}
end

def close(state = %{bookie: bookie}) do
    r = :leveled_bookie.book_close(bookie)
    {r, state}
end


@type foldl_fun :: (
    {{bucket:: binary(), key :: binary()}, any()} -> list()
)

 @spec foldl(
     fun  :: foldl_fun,
         accumulator  :: list(),
         state :: state()) :: {
             acc_out :: list(), state :: map()
         }
def foldl(fun, acc0, state=%{bookie: bookie}) do
    fold_objects_fun = fn(b, k, v, acc) -> fun.({{b, k}, v}, acc) end
    {:async, fold_fn} = :leveled_bookie.book_returnfolder(bookie, {:foldobjects_allkeys,
                                                                @std_tag,
                                                                {fold_objects_fun, acc0},
                                                                true})
    acc_out = fold_fn.()
    {acc_out, state}
end

def delete(state=%{base_path: path}) do
  r = remove_path(path)
  {r, state}
end

# % private functions

def sub_files(dir) do
    {:ok, sub_files} = :file.list_dir(dir)
    for f <- sub_files, do: :filename.join(dir,f)
end

def remove_path(path) do
  case :filelib.is_dir(path) do
         false ->
             :file.delete(path)
         true ->
             :lists.foreach(fn(child_path) -> remove_path(child_path) end,
                           sub_files(Path))
             :file.del_dir(path)
    end
   end
end
