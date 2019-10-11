defmodule EchoServerWeb.CallbackController do
  use EchoServerWeb, :controller
  require Logger
  alias EchoServer.{EchoOp, EchoOps, EchoParams}

  @allowed_statuses [200, 201, 204, 404, 500]

  def create(%{body_params: json_data, query_params: params} = conn, _params) do
    Logger.info("Create called")

    conn
    |> handle_request(json_data, params)
    |> json(%{})
  end

  def update_params(conn, params) do
    EchoParams.update_params(params)
    json(conn, %{})
  end

  defp handle_request(conn, json_data, caller_params) do
    global_params = EchoParams.params()

    op = create_op(json_data, global_params, caller_params)
    EchoOps.add_op(op)
    status = return_status(op)

    conn
    |> sleep(op)
    |> put_status(status)
  end

  defp sleep(conn, %{delay: 0}), do: conn

  defp sleep(conn, %{delay: secs}) do
    Process.sleep(secs * 1_000)
    conn
  end

  defp return_status(%{response_sent: status}) do
    status
  end

  defp create_op(json_data, global_params, caller_params) do
    id = caller_params["id"]
    delay = delay(global_params.delay, caller_params["delay"])
    response = response(global_params.status, caller_int_param(caller_params["response"]))
    Logger.info("id = #{inspect(id)}, delay =#{inspect(delay)}, response = #{inspect(response)} ")
    json_key = json_key(json_data, caller_params["key"])
    Logger.info("json key = #{inspect(json_key)}")
    op = EchoOp.new(id, json_data, response, delay, json_key)
    Logger.info("Got past EchoOp.new")
    op
  end

  defp delay(global_delay, nil), do: global_delay

  defp delay(global_delay, caller_delay) do
    case Integer.parse(caller_delay) do
      :error -> global_delay
      {int_val, _remainder} -> int_val
    end
  end

  defp response(_global_response, caller_response) when caller_response in @allowed_statuses,
    do: caller_response

  defp response(global_response, _caller_response) when global_response in @allowed_statuses,
    do: global_response

  defp response(_, _), do: 201

  defp json_key(_json_data, nil), do: ""

  defp json_key(json_data, key) when is_map(json_data) do
    Map.get(json_data, key, "")
  end

  defp json_key(_, _), do: ""

  defp caller_int_param(nil), do: nil

  defp caller_int_param(val) do
    case Integer.parse(val) do
      :error -> nil
      {int_val, _} -> int_val
    end
  end
end
