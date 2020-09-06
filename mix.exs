defmodule MixReadme.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_readme,
      version: "0.2.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Generate a README based on the moduledoc of your app.",
      package: package(),
      source_url: "https://github.com/thomas9911/mix_readme",
      docs: [
        main: "Mix.Tasks.Readme",
        extra_section: []
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["Unlicense"],
      links: %{"GitHub" => "https://github.com/thomas9911/mix_readme"}
    ]
  end
end
