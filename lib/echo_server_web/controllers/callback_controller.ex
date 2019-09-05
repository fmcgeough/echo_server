defmodule EchoServerWeb.CallbackController do
  use EchoServerWeb, :controller
  require Logger
  alias EchoServer.{EchoOp, EchoOps, EchoParams}

  def create(conn, params) do
    conn
    |> handle_request(params)
    |> json(%{})
  end

  def update_params(conn, params) do
    EchoParams.update_params(params)
    json(conn, %{})
  end

  defp handle_request(conn, caller_params) do
    params = EchoParams.params()
    status = return_status(params)

    conn
    |> add_to_ops(caller_params, status)
    |> delay(params)
    |> put_status(status)
  end

  defp delay(conn, %{delay: 0}), do: conn

  defp delay(conn, %{delay: secs}) do
    Process.sleep(secs)
    conn
  end

  defp return_status(%{random: true}) do
    Enum.random([200, 201, 204, 404, 500])
  end

  defp return_status(%{status: status, random: false}) do
    status
  end

  defp add_to_ops(conn, params, status) do
    EchoOps.add_op(EchoOp.new(params, status))
    conn
  end
end
