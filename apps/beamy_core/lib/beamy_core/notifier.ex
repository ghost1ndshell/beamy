defmodule BeamyCore.Notifier do
  @moduledoc """
  Notifier module for broadcasting events to rooms.
  """
  @callback broadcast_room(
              room_id :: String.t(),
              event :: String.t(),
              payload :: map()
            ) :: :ok
end
