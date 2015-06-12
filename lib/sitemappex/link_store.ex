defmodule Sitemappex.LinkStore do
  use GenServer

  ## Client API

  @doc """
  Starts the LinkStore GenServer.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Adds a URL to the LinkStore

  Returns `{:existing, count}` if the url exists, `:new` otherwise.
  """
  def add(store, url) do
    GenServer.call(store, {:add, url})
  end

  @doc """
  Converts the LinkStore to a list of tuples

  Returns a List of tuples, `{url, count}`.
  """
  def to_list(store) do
    GenServer.call(store, :to_list)
  end

  ## Server Callbacks

  defp add_url({:ok, count}, urls, url) do
    count = count + 1
    {:reply, {:existing, count}, HashDict.put(urls, url, count)}
  end

  defp add_url(:error, urls, url) do
    {:reply, :new, HashDict.put(urls, url, 1)}
  end

  def handle_call({:add, url}, _from, urls) do
    urls
    |> HashDict.fetch(url)
    |> add_url(urls, url)
  end

  def handle_call(:to_list, _from, urls) do
    {:reply, HashDict.to_list(urls), urls}
  end

  def init(:ok) do
    {:ok, HashDict.new}
  end
end
