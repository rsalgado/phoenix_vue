defmodule PhoenixVueBackendWeb.ClockChannel do
  use PhoenixVueBackendWeb, :channel

  def join("clock:lobby", payload, socket) do
    # Send initial message to itself and accept joining the channel with `:ok` response
    send(self(), {:clock_tick, current_time()})
    {:ok, socket}
  end

  defp current_time() do
    Time.utc_now()
    |> Time.to_iso8601()
    |> String.slice(0..7)
  end

  def handle_info({:clock_tick, time_string}, socket) do
    # Build payload and send it to channel's client as an "update_time" event
    payload = %{body: time_string}
    push(socket, "update_time", payload)

    # Schedule the next clock tick message to itself
    schedule_next_tick()
    # As this was an internal async message from itself, we don't reply
    {:noreply, socket}
  end

  defp schedule_next_tick() do
    Process.send_after(
      self(),
      {:clock_tick, current_time()},
      :timer.seconds(1)
    )
  end

end
