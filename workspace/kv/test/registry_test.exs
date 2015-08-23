defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  defmodule Forwarder do
    use GenEvent
    def handle_event(event, parent) do
      send parent, event
      {:ok, parent}
    end
  end

  setup do
    {:ok, sup} = KV.Bucket.Supervisor.start_link
    {:ok, manager} = GenEvent.start_link
    {:ok, registry} = KV.Registry.start_link(:registry_table, manager, sup)

    GenEvent.add_mon_handler(manager, Forwarder, self())
    {:ok, registry: registry, ets: :registry_table}
  end

  test "spawns buckets", %{registry: registry, ets: ets } do
    assert KV.Registry.lookup(ets,"shopping") == :error

    KV.Registry.create(registry, "shopping")

    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "remove buckets on exit", %{registry: registry, ets: ets} do
    KV.Registry.create(registry, "shipping")
    {:ok, bucket} = KV.Registry.lookup(ets, "shipping")
    Agent.stop(bucket)
    assert KV.Registry.lookup(ets, "shipping") == :error
  end

  test "send events on create and crash", %{registry: registry, ets: ets} do
    KV.Registry.create(registry, "shipping")
    {:ok, bucket} = KV.Registry.lookup(ets, "shipping")
    assert_receive {:create, "shipping", ^bucket}
    Agent.stop(bucket)
    assert_receive {:exit, "shipping", ^bucket}
  end

  test "removes bucket on crash", %{registry: registry, ets: ets} do
    KV.Registry.create(registry, "shipping")
    {:ok, bucket} = KV.Registry.lookup(ets, "shipping")
    #kill the bucket
    Process.exit(bucket, :shutdown)
    assert_receive {:exit, "shipping", ^bucket}
    assert KV.Registry.lookup(ets, "shipping") == :error
  end
end
