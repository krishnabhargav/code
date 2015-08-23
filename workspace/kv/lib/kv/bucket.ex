defmodule KV.Bucket do
  def start_link do
    Agent.start_link(&HashDict.new/0)
  end

  def get(bucket, k) do
    Agent.get bucket, &HashDict.get(&1, k)
  end

  def put(bucket, k, v) do
    Agent.update bucket, &HashDict.put(&1, k, v)
  end

  def delete(bucket, k) do
    Agent.get_and_update bucket, &HashDict.pop(&1, k)
  end
end
