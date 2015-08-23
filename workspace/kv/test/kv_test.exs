defmodule KVTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, :k) == nil
    KV.Bucket.put bucket, :k, 3
    assert KV.Bucket.get(bucket, :k) == 3
  end
  
end
