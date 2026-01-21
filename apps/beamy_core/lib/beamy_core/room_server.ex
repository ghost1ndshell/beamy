defmodule BeamyCore.RoomServer do
  use GenServer

  def start_link(opts) do
    room_id = Keyword.fetch!(opts, :room_id)
    GenServer.start_link(__MODULE__, opts, name: via(room_id))
  end

  def via(room_id), do: {:via, Registry, {BeamyCore.RoomRegistry, room_id}}

  @impl true
  def init(opts) do
    state = %{
      room_id: Keyword.fetch!(opts, :room_id),
      join_token: Keyword.fetch!(opts, :join_token),
      # user_id => meta
      members: %{}
    }

    {:ok, state}
  end
end
