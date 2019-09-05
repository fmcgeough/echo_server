defmodule EchoServer.EchoOps do
  use GenServer
  alias EchoServer.EchoOp

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def recent_ops do
    GenServer.call(__MODULE__, :recent_ops)
  end

  def add_op(%EchoOp{} = op) do
    GenServer.cast(__MODULE__, {:add_op, op})
  end

  def handle_call(:recent_ops, _, state) do
    {:reply, state, state}
  end

  def handle_cast({:add_op, op}, state) do
    state =
      state
      |> Enum.slice(0, 9)
      |> Enum.concat([op])

    {:noreply, state}
  end
end
