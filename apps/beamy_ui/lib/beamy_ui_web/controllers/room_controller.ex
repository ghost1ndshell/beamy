defmodule BeamyUiWeb.RoomController do
  use BeamyUiWeb, :controller

  # Post /api/rooms
  # body: {"room_name": "optional"}
  def create(conn, params) do
    room_name = Map.get(params, "room_name", "")

    case BeamyCore.create_room(%{room_name: room_name}) do
      {:ok, room} ->
        json(conn, %{
          room_id: room.room_id,
          token: room.token,
          room_salt: room.room_salt_b64
        })

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: to_string(reason)})
    end
  end
end
