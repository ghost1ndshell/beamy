defmodule BeamyUiWeb.RoomChannel do
  use BeamyUiWeb, :channel

  alias BeamyUiWeb.Presence

  @impl true
  def join(
        "room:" <> room_id,
        %{
          "user_id" => user_id,
          "token" => token
        } = _payload,
        socket
      ) do
    # notifier uses PubSub with {event, payload} tuples,
    # so is expected to subscribe in the channel process.
    Phoenix.PubSub.subscribe(Beamy.PubSub, "room:#{room_id}")

    case BeamyCore.join_room(room_id, token, %{user_id: user_id}) do
      {:ok, %{room_salt_b64: room_salt_b64}} ->
        socket =
          socket
          |> assign(:room_id, room_id)
          |> assign(:user_id, user_id)

        # track presence
        {:ok, _} =
          Presence.track(socket, user_id, %{
            online_at: System.system_time(:second)
          })

        presence_state = Presence.list(socket)

        {:ok,
         %{
           room_id: room_id,
           room_salt: room_salt_b64,
           presence_state: presence_state
         }, socket}

      {:error, :room_not_found} ->
        {:error, %{reason: "room_not_found"}}

      {:error, :unauthorized} ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("room:" <> _room_id, _payload, _socket) do
    {:error, %{reason: "missing_user_id_or_token"}}
  end

  @doc """
    Client sends ciphertext envelope; server relays as-is.
    payload format: {"envelope": {...}, "client_msg_id": "uuid", "sent_at": 123}
  """
  @impl true
  def handle_in("ciphertext", %{"envelope" => envelope} = payload, socket) do
    room_id = socket.assigns.room_id
    user_id = socket.assigns.user_id

    # Core policy check / rate limiting
    case BeamyCore.publish(room_id, %{
           from: user_id,
           envelope: envelope,
           meta: Map.drop(payload, ["envelope"])
         }) do
      :ok ->
        {:noreply, socket}

      {:error, :rate_limited} ->
        push(socket, "error", %{reason: "rate_limited"})
        {:noreply, socket}

      {:error, :room_not_found} ->
        push(socket, "error", %{reason: "room_not_found"})
        {:noreply, socket}
    end
  end

  # Core broadcasts -> channel receives via PubSub -> channel pushes to connected clients
  @impl true
  def handle_info({event, payload}, socket) when is_binary(event) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end
