
See tanodb implementation for the means to store multiple copies of the data:




https://github.com/marianoguerra/tanodb/blob/7b8bb0ddc0fd1e67b2522cff8a0dac40b412acdb/apps/tanodb/src/tanodb_write_fsm.erl#L61-L77



```

prepare(timeout, SD0=#state{n=N, key=Key}) ->
    DocIdx = riak_core_util:chash_key(Key),
    Preflist = riak_core_apl:get_apl(DocIdx, N, tanodb),
    SD = SD0#state{preflist=Preflist},
    {next_state, execute, SD, 0}.


%% @doc Execute the write request and then go into waiting state to
%% verify it has meets consistency requirements.
execute(timeout, SD0=#state{req_id=ReqID, key=Key, action=Action, data=Data,
                            preflist=Preflist}) ->
    Command = case Action of
                  delete -> {delete, ReqID, Key};
                  write -> {put, ReqID, Key, Data}
              end,
    riak_core_vnode_master:command(Preflist, Command, {fsm, undefined, self()},
                                   tanodb_vnode_master),
    {next_state, waiting, SD0}.

```