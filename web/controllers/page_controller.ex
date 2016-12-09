defmodule Joust.PageController do
  use Joust.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
