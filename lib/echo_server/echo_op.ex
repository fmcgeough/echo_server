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
      json_md5: :crypto.hash(:md5, "#{inspect(json)}") |> Base.encode16(),
      response_sent: response_sent,
      time_received: DateTime.utc_now(),
      delay: delay,
      json_key: json_key
    }
  end

  defp echo_id(nil) do
    EchoServer.EchoID.generate()
  end

  defp echo_id(id), do: id
end
