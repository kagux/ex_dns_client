defmodule ExDnsClient.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_dns_client,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: "A rudimentary DNS client.  Thin wrapper around erlang's `inet_res` library",
     name: "ExDnsClient",
     source_url: "htpps://github.com/kagux/ex_dns_client",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:dialyxir, "~> 0.4", only: [:dev], runtime: false}]
  end

  defp package do
    [description: "A rudimentary DNS client.  Thin wrapper around erlang's `inet_res` library",
     files: ["lib", "config", "mix.exs", "README*"],
     maintainers: ["Boris Mikhaylov"],
     licenses: ["MIT"],
     links: %{github: "htpps://github.com/kagux/ex_dns_client"}]
  end
end
