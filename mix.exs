defmodule TokenAuth.MixProject do
  use Mix.Project

  def project do
    [
      app: :token_auth,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:plug, "~> 1.7.1"}
    ]
  end

  defp description do
    "A Plug for simple Bearer authentication"
  end

  defp package do
    [
      name: :token_auth,
      files: ~w(mix.exs lib .formatter.exs README.md LICENSE),
      maintainers: ["Jacopo Cascioli"],
      licenses: ["MPL 2.0"],
      links: %{"GitHub" => "https://github.com/Vesuvium/token_auth"}
    ]
  end
end