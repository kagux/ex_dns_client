defmodule ExDnsClient.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_dns_client,
     version: "0.1.1",
     elixir: "~> 1.3",
     description: "A rudimentary DNS client. Thin wrapper around erlang's `inet_res` library",
     name: "ExDnsClient",
     source_url: "https://github.com/kagux/ex_dns_client",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:dialyxir, "~> 0.4", only: :dev, runtime: false},
      {:dns, "~> 0.0.3", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
   ]
  end

  defp package do
    [description: "A rudimentary DNS client. Thin wrapper around erlang's `inet_res` library",
     files: ["lib", "config", "mix.exs", "README*"],
     maintainers: ["Boris Mikhaylov"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/kagux/ex_dns_client"}]
  end
end
