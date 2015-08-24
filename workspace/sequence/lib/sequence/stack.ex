defmodule Sequence.Stack do
  use GenServer

  def handle_call(:pop, _from, newState) do
    [h | t] = newState
    { :reply, h, t}
  end

  def handle_cast({:reset, ns}, state) do
    {:noreply, ns}
  end

  def terminate(p, state) do
    IO.puts p
  end
end
