defmodule ExDnsClient do
  @moduledoc """
  A rudimentary DNS client.
  Thin wrapper around erlang's `inet_res` library 
  """

  @type ip4_address :: {0..255, 0..255, 0..255, 0..255}
  @type ip6_address :: {0..65535, 0..65535, 0..65535, 0..65535, 0..65535, 0..65535, 0..65535, 0..65535}
  @type ip_address :: ip4_address | ip6_address
  @type nameserver :: {ip_address, {:port, 1..65535}}
  @type dns_record_class :: [:in | :chaos | :hs | :any]
  @type dns_record_type :: [ :a | :aaaa | :cname | :gid | :hinfo | :ns | :mb | :md |
                         :mg | :mf | :minfo | :mx | :naptr | :null | :ptr | :soa |
                         :spf | :srv | :txt | :uid | :uinfo | :unspec | :wks ]

  @doc """
  Resolves the DNS data for the record of the specified type and class for the specified name.
  On success, filters out the answer records with the correct Class and Type, and returns a list of their data fields.
  So, a lookup for type any gives an empty answer, as the answer records have specific types that are not any.
  An empty answer or a failed lookup returns an empty list.
  """
  @type lookup_opts :: [
    {:class, dns_record_class} |
    {:type, dns_record_type} |
    {:alt_nameservers, [nameserver, ...]} |
    {:edns, 0 | false} |
    {:inet6, boolean} |
    {:nameservers, [nameserver, ...]} |
    {:recurse, boolean} |
    {:retry, integer} |
    {:timeout, integer} |
    {:udp_payload_size, integer} |
    {:usevc, boolean}
  ]
  @type dns_data :: [String.t] | [ip4_address] | [ip6_address]
  @spec lookup(name :: String.t, opts :: lookup_opts) :: dns_data
  def lookup(name, opts \\ []) do
    class = opts |> Keyword.get(:class, :in)
    type = opts |> Keyword.get(:type, :a)
    name
    |> to_charlist
    |> :inet_res.lookup(class, type)
    |> Enum.map(&charlist_to_string/1)
  end

  defp charlist_to_string(list) when is_list(list) do
    list |> to_string
  end
  defp charlist_to_string(arg), do: arg
end
