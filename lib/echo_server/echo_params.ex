defmodule EchoServer.EchoParams do
  use GenServer

  @allowed_statuses [200, 201, 204, 404, 500]

  def start_link do
    GenServer.start_link(__MODULE__, %{status: 201, delay: 0, random: false}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def params do
    GenServer.call(__MODULE__, :params)
  end

  def update_params(params) do
    GenServer.cast(__MODULE__, {:set_params, params})
  end

  def handle_call(:params, _, state) do
    {:reply, state, state}
  end

  def handle_cast({:set_params, params}, state) do
    state =
      state
      |> update_state(:random, params["random"])
      |> update_state(:delay, params["delay"])
      |> update_state(:status, params["status"])

    {:noreply, state}
  end

  defp update_state(state, :random, val) when val in [true, false] do
    %{state | random: val}
  end

  defp update_state(state, :delay, val) when val in [0..60] do
    %{state | delay: val}
  end

  defp update_state(state, :status, val) when val in @allowed_statuses do
    %{state | status: val}
  end

  defp update_state(state, _, _val), do: state
end
