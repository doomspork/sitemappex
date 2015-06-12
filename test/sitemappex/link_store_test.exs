defmodule Sitemappex.LinkStoreTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, link_store} = Sitemappex.LinkStore.start_link
    {:ok, link_store: link_store}
  end

  test "responds to new and existing correctly", %{link_store: link_store} do
    assert :new = Sitemappex.LinkStore.add(link_store, "http://example.org")
    assert {:existing, count} = Sitemappex.LinkStore.add(link_store, "http://example.org")
    assert ^count = 2
  end

  test "responds to to_list", %{link_store: link_store} do
    Sitemappex.LinkStore.add(link_store, "http://example.org")
    assert [{_, 1}] = Sitemappex.LinkStore.to_list(link_store)
  end
end
