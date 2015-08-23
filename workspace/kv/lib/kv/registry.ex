defmodule KV.Registry do
  use GenServer

  #client api
  def start_link(table, event_manager, buckets, opts \\ []) do
    # __MODULE__ means the current module,
    # intialization arguments here is just :ok,
    #list of options is opts (can hold name of the server)
    GenServer.start_link(__MODULE__, {table, event_manager, buckets} , opts)
  end

  def lookup(table, name) do
    #GenServer.call(server, {:lookup, name})
    case :ets.lookup(table, name) do
      [{^name, bucket}] -> {:ok, bucket}
      [] -> :error
    end
  end

  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  def stop(server) do
    GenServer.call(server, :stop)
  end

  ##Server callbacks
  def init({table, event_manager, buckets}) do
    #callback for GenServer.start_link/3 server call
    # Genserver expected to return {:ok, state}
    #names = HashDict.new
    refs = HashDict.new
    ets = :ets.new(table, [:named_table, read_concurrency: true])
    {:ok, %{names: ets, refs: refs, events: event_manager, buckets: buckets}}
  end

  #callback for GenServer.call 
  def handle_call({:lookup, name}, _from, state) do
    #{:reply, reply, new_state} should be returned
    {:reply, HashDict.fetch(state.names, name), state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  #callback for GenServer.cast
  def handle_cast({:create, name}, state) do
    #{:noreply, new_state} should be returned
    case lookup state.names, name do
      {:ok, _pid} -> {:noreply, state}
      :error ->
        {:ok, bucket} = KV.Bucket.Supervisor.start_bucket(state.buckets)
        ref = Process.monitor(bucket)

        refs = HashDict.put(state.refs, ref, name)
        :ets.insert(state.names, {name, bucket})

        GenEvent.sync_notify(state.events, {:create, name, bucket})
        {:noreply, %{state | refs: refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    {name, refs} = HashDict.pop(state.refs, ref) # use the ref to get the process name
    :ets.delete(state.names, name)

    GenEvent.sync_notify(state.events, {:exit, name, _pid})

    {:noreply, %{state | refs: refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
