defmodule EchoServerWeb.CallbackController do
  use EchoServerWeb, :controller
  require Logger
  alias EchoServer.EchoParams

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

    conn
    |> output_info(caller_params)
    |> delay(params)
    |> set_return_status(params)
  end

  defp delay(conn, %{delay: 0}), do: conn

  defp delay(conn, %{delay: secs}) do
    Process.sleep(secs)
    conn
  end

  defp set_return_status(conn, %{random: true}) do
    put_status(conn, Enum.random([200, 201, 204, 404, 500]))
  end

  defp set_return_status(conn, %{status: status, random: false}) do
    put_status(conn, status)
  end

  defp output_info(conn, params) do
    Logger.info("Caller sent => #{inspect(params)}")
    Logger.info("Headers => #{inspect(conn.req_headers)}")
    conn
  end
end
