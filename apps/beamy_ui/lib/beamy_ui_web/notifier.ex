defmodule BeamyUiWeb.Notifier do
  @behaviour BeamyCore.Notifier

  @impl true
  def broadcast_room(room_id, event, payload) do
    Phoenix.PubSub.broadcast(Beamy.PubSub, "room:#{room_id}", {event, payload})
    :ok
  end
end
