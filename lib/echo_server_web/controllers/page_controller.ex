defmodule EchoServerWeb.PageController do
  use EchoServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
