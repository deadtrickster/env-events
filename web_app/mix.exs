defmodule WebApp.Mixfile do
  use Mix.Project

  def project do
    [app: :web_app,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {WebApp, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:amqp, "~> 1.0.0-pre.1"},
     {:cowboy, "~> 1.1"},
     {:plug, "~> 1.4"},
     {:poison, "~> 3.1"},
     {:prometheus_plugs, "~> 1.1"},
     {:prometheus_ex, "~> 1.3"},
     {:prometheus_process_collector, "~> 1.1"},
     {:fuse, "~> 2.4"},
     {:ex_doc, "~> 0.16.2", only: :dev},
     {:inch_ex, "~> 0.5.6", only: [:dev, :test]}]
  end
end
