require HTTPoison
require Logger
require Floki

defmodule Sitemappex do
  def main(args) do
    {opts, urls, _} = OptionParser.parse(args, strict: [])

    urls
    |> String.split
    |> Enum.map(&([&1, map_links(&1)]))
  end

  def map_links(starting_url, whitelist \\ []) do
    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: Sitemappex.TaskSupervisor]]),
      worker(Sitemappex.LinkStore, [[name: Sitemappex.LinkStore]]),
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])

    new_worker(starting_url)

    Sitemappex.LinkStore
    |> crawl(whitelist, %{finished: 0, requested: 1})
    |> to_list
  end

  defp crawl(link_store, whitelist, status = %{finished: f, requested: n}) when (f != n) do
    receive do
      {:link, url} ->
        if is_whitelisted(url, whitelist) do
          status = handle_link(link_store, url, status)
        end
        crawl(link_store, whitelist, status)
      :done ->
        crawl(link_store, whitelist, %{status | finished: f + 1} )
    end
  end

  defp crawl(link_store, _, %{finished: f, requested: n}) when (f == n) do
    link_store
  end

  defp new_worker(url) do
    Task.Supervisor.start_child(Sitemappex.TaskSupervisor, __MODULE__ , :find_links, [self(), url])
  end

  defp handle_link(link_store, url, status = %{finished: _, requested: n}) do
    case Sitemappex.LinkStore.add(link_store, url) do
      :new ->
        new_worker(url)
        %{status | requested: n + 1}
      {:existing, _} ->
        status
    end
  end

  defp is_whitelisted(url, whitelist) do
    case length(whitelist) do
      0 -> true
      _ -> Enum.any?(whitelist, fn (listed) -> String.contains?(url, listed) end)
    end
  end

  def find_links(parent, url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Floki.find("a")
        |> Floki.attribute("href")
        |> Enum.map(fn(url) -> send(parent, {:link, url}) end)
        _ -> Logger.warn "Unable to load #{url}"
    end

    send(parent, :done)
  end

  defp to_list(link_store) do
    Sitemappex.LinkStore.to_list(link_store)
  end
end
