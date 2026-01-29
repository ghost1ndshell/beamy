defmodule BeamyCore do
  @moduledoc """
  `BeamyCore` facade used by controller/channel.
  """
  alias BeamyCore.Rooms

  defdelegate create_room(attrs \\ %{}), to: Rooms
  defdelegate join_room(room_id, token, user_meta), to: Rooms
  defdelegate publish(room_id, payload), to: Rooms
end
