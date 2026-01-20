defmodule BeamyUiWeb.PageController do
  use BeamyUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
