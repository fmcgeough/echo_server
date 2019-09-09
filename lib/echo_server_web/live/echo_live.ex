defmodule EchoServerWeb.EchoLive do
  @moduledoc """
  Let user see recent ops against server
  """
  use Phoenix.LiveView
  use Phoenix.HTML
  alias EchoServer.EchoOps
  alias EchoServerWeb.EchoLiveView

  def render(assigns) do
    EchoLiveView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)
    {:ok, assign(socket, recent_ops: EchoOps.recent_ops())}
  end

  def handle_info(:tick, socket) do
    {:noreply, assign(socket, recent_ops: EchoOps.recent_ops())}
  end
end
