defmodule BeamyCore.RoomServer do
  alias Hex.API.Key
  use GenServer

  def start_link(opts) do
    room_id = Keyword.fetch!(opts, :room_id)
    GenServer.start_link(__MODULE__, opts, name: via(room_id))
  end

  def via(room_id), do: {:via, Registry, {BeamyCore.RoomRegistry, room_id}}

  def join(room_id, token, user_meta) do
    case GenServer.whereis(via(room_id)) do
      nil -> {:error, :room_not_found}
      _pid -> GenServer.call(via(room_id), {:join, token, user_meta})
    end
  end

  def publish(room_id, payload) do
    case GenServer.whereis(via(room_id)) do
      nil -> {:error, :room_not_found}
      _pid -> GenServer.call(via(room_id), {:publish, payload})
    end
  end

  @impl true
  def init(opts) do
    state = %{
      room_id: Keyword.fetch!(opts, :room_id),
      token: Keyword.fetch!(opts, :token),
      room_salt_b64: Keyword.fetch!(opts, :room_salt_b64)
    }

    {:ok, state}
  end

  @doc """
  Broadcast immediately (ciphertext only)
  """
  @impl true
  def handle_call({:publish, payload}, _from, state) do
    {:reply, :ok, state}
  end

  defp notifier do
    Application.get_env(:beamy_core, :notifier, BeamyCore.Notifier.Noop)
  end
end
