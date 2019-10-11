defmodule EchoServer.EchoOp do
  @moduledoc """
  Info on the POST to /api/callback
  """
  defstruct id: nil,
            json_md5: nil,
            response_sent: 201,
            time_received: nil,
            delay: 0,
            json_key: nil

  def new(id, json, response_sent, delay, json_key) do
    %__MODULE__{
      id: echo_id(id),
      json_md5: jason_md5(json),
      response_sent: response_sent,
      time_received: DateTime.utc_now(),
      delay: delay,
      json_key: json_key("#{inspect(json_key)}")
    }
  end

  defp echo_id(nil) do
    EchoServer.EchoID.generate()
  end

  defp echo_id(id) do
    String.slice(id, 0, 64)
  end

  defp json_key(nil), do: nil

  defp json_key(key) do
    String.slice(key, 0, 64)
  end

  defp jason_md5(nil), do: ""

  defp jason_md5(json) do
    :crypto.hash(:md5, "#{inspect(json)}") |> Base.encode16()
  end
end
