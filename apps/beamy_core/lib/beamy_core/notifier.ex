defmodule BeamyCore.Notifier do
  @callback broadcast_room(
              room_id :: String.t(),
              event :: String.t(),
              payload :: map()
            ) :: :ok
end
