defmodule WebApp do

  require Prometheus.Registry
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    WebAppRouter.PlugExporter.setup()
    WebAppRouter.PlugPipelineInstrumenter.setup()
    Prometheus.Registry.register_collector(:prometheus_process_collector)

    {:ok, conn} = AMQP.Connection.open(host: "rabbitmq")
    {:ok, chan} = AMQP.Channel.open(conn)
    AMQP.Queue.declare(chan, "web_app_queue")
    
    children = [
      # Define workers and child supervisors to be supervised
      Plug.Adapters.Cowboy.child_spec(:http, WebAppRouter, [], [port: String.to_integer(System.get_env("PORT"))])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
