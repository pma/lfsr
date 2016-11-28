defmodule LFSR.Mixfile do
  use Mix.Project

  @version "0.0.2"

  def project do
    [app: :lfsr,
     version: @version,
     elixir: "~> 1.0",
     deps: deps(),
     package: package(),
     description: description(),
     name: "LFSR",
     docs: [extras: ["README.md"], main: "extra-readme",
            source_ref: "v#{@version}",
            source_url: "https://github.com/pma/lfsr"]]
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
     maintainers: ["Paulo Almeida"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/pma/lfsr"}]
  end
end
