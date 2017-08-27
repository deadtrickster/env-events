defmodule WebAppRouter do
  use Plug.Router

  defmodule PlugExporter do
    use Prometheus.PlugExporter
  end

  defmodule PlugPipelineInstrumenter do
    use Prometheus.PlugPipelineInstrumenter
  end

  plug PlugExporter
  plug PlugPipelineInstrumenter
  plug :match
  plug :dispatch

  get "/put_messages/:count" do
    case Application.get_env(:web_app, :status, :ok) do
      :ok ->
        count = String.to_integer(conn.params["count"])
        {:ok, amqp} = AMQP.Connection.open(host: "rabbitmq")
        {:ok, chan} = AMQP.Channel.open(amqp)
        for _ <- 1..count do
          AMQP.Basic.publish(chan, "", "web_app_queue", "Hello, World!")
        end
        send_resp(conn, 200, "done!")
      :high_load ->
        send_resp(conn, 503, "high load!")
    end
  end

  get "/messages/:count" do    
    count = String.to_integer(conn.params["count"])
    {:ok, amqp} = AMQP.Connection.open(host: "rabbitmq")
    {:ok, chan} = AMQP.Channel.open(amqp)
    for _ <- 1..count do
      AMQP.Basic.get(chan, "web_app_queue", no_ack: true)
    end
    send_resp(conn, 200, "done!")
  end

  post "/alerts" do
    {:ok, alert, conn} = read_body(conn)
    alert = Poison.decode!(alert)
    IO.puts(inspect(alert))
    case alert["status"] do
      "firing" -> Application.put_env(:web_app, :status, :high_load)
      _ -> Application.delete_env(:web_app, :status)
    end
    send_resp(conn, 200, "thanks!")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
