defmodule BeamyUiWeb.Presence do
  use Phoenix.Presence,
    otp_app: :beamy_ui,
    pubsub_server: BeamyCore.PubSub
end
