defmodule PhoenixVueBackendWeb.UserSocket do
  use Phoenix.Socket

  channel "clock:lobby", PhoenixVueBackendWeb.ClockChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
