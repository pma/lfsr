defmodule LFSR.Mixfile do
  use Mix.Project

  def project do
    [app: :lfsr,
     version: "0.0.2",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps,
     docs: [readme: true, main: "README"]]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :docs},
     {:ex_doc, "~> 0.10", only: :docs}]
  end

  defp description do
    """
    Elixir implementation of a binary Galois Linear Feedback Shift Register.
    """
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     contributors: ["Paulo Almeida"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/pma/lfsr"}]
  end
end
