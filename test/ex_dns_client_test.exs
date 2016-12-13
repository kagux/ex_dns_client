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
end
