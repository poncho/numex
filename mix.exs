defmodule Numex.Mixfile do
  use Mix.Project

  def project do
    [app: :numex,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def description do
    """
    Collection of mathematical functions
    """
  end

  def package do
    [
     name: :numex,
     maintainers: ["Alfonso Martínez", "Alvaro Lizama", "Oscar Olivera"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/ponchomf/postgrex"}]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:timex, "~> 3.1"},
      {:ex_doc, "~> 0.15.1", only: :dev},
      {:excoveralls, "~> 0.6.3", only: :test},
      {:credo, "~> 0.7.3", only: [:dev, :test]},
      {:xlsxir, "~> 1.5"},
      {:decimal, "~> 1.3"},
    ]
  end
end
