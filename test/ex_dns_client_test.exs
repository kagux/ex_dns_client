defmodule ExDnsClientTest do
  use ExUnit.Case, async: true

  test "lookup/1 returns type A record of IN class" do
    assert ExDnsClient.lookup("google-public-dns-a.google.com") == [{8, 8, 8, 8}]
  end

  test "lookup/2 returns record of requested type" do
    expected = MapSet.new(["a.iana-servers.net", "b.iana-servers.net"])
    result = ExDnsClient.lookup("example.com", type: :ns) |> MapSet.new
    assert result == expected
  end

  test "lookup/2 accepts same options as inet_res" do
    ip = {192, 168, 1, 1}
    DnsServer.add_response("example.com", :a, ip)
    assert ExDnsClient.lookup("example.com", nameservers: [{{127, 0, 0, 1}, 8053}]) == [ip]
  end
end
