defmodule EchoServer.EchoOp do
  defstruct json: nil, response_sent: 201, time_received: nil

  def new(json, response_sent) do
    %__MODULE__{
      json: "#{inspect(json)}",
      response_sent: response_sent,
      time_received: DateTime.utc_now()
    }
  end
end
