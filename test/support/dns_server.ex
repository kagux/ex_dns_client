defmodule DnsServer do
  use GenServer
  @behaviour DNS.Server

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def stop do
    GenServer.stop(__MODULE__)
  end

  def add_response(domain, type, response) do
    GenServer.cast(__MODULE__, {:add_response, domain, type, response})
  end

  def handle(record, _) do
    query = hd(record.qdlist)
    response = GenServer.call(__MODULE__, {:get_response, to_string(query.domain), query.type})
    resources = response
    |> List.wrap
    |> Stream.map(&hosts_to_charlists/1)
    |> Enum.map(fn addr ->
      %DNS.Resource{
        domain: query.domain,
        class: query.class,
        type: query.type,
        ttl: 300,
        data: addr
      }
    end)

    %{record | anlist: resources}
  end

  def init(opts) do
    GenServer.cast(__MODULE__, {:start, opts[:port]})
    {:ok, %{}}
  end

  def handle_cast({:start, port}, state) do
    spawn_link fn ->
      DNS.Server.accept port, __MODULE__
    end
    {:noreply, state}
  end

  def handle_cast({:add_response, domain, type, response}, state) do
    state = state |> Map.put({domain, type}, response)
    {:noreply, state}
  end

  def handle_call({:get_response, domain, type}, _from, state) do
    response = state |> Map.get({domain, type}, "")
    {:reply, response, state}
  end

  defp hosts_to_charlists(str) when is_bitstring(str), do: str |> to_charlist
  defp hosts_to_charlists(arg), do: arg
end
