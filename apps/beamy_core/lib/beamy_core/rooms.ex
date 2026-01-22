defmodule BeamyCore.Rooms do
  alias BeamyCore.RoomServer

  def create_room(_attrs \\ %{}) do
    room_id = new_id()
    token = new_token()
    room_salt = :crypto.strong_rand_bytes(16)
    room_salt_b64 = Base.url_encode64(room_salt, padding: false)

    spec = {RoomServer, room_id: room_id, token: token, room_salt_b64: room_salt_b64}

    case DynamicSupervisor.start_child(BeamyCore.RoomServer, spec) do
      {:ok, _pid} ->
        {:ok, %{room_id: room_id, token: token, room_salt_b64: room_salt_b64}}

      {:error, {:already_started, _pid}} ->
        {:ok, %{room_id: room_id, token: token, room_salt_b64: room_salt_b64}}

      _ ->
        {:error, "Failed to create room"}
    end
  end

  def join_room(room_id, token, user_meta) do
    case RoomServer.join(room_id, token, user_meta) do
      {:ok, room_salt_b64} -> {:ok, %{room_salt_b64: room_salt_b64}}
      {:error, _} = err -> err
    end
  end

  def publish(room_id, payload) do
    RoomServer.publish(room_id, payload)
  end

  defp new_id, do: Base.url_encode64(:crypto.strong_rand_bytes(9), padding: false)
  defp new_token, do: Base.url_encode64(:crypto.strong_rand_bytes(24), padding: false)
end
