defmodule BeamyCore.Notifier.Noop do
  @behaviour BeamyCore.Notifier
  @impl true
  def broadcast_room(_room_id, _event, _payload), do: :ok
end
