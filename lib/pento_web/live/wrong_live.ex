defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess:", luck_number: Enum.random(1..10))}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    {parsed_guess, _} = Integer.parse(guess)
    state = if parsed_guess != socket.assigns.luck_number do
      %{score: socket.assigns.score - 1, message: "Your guess: #{guess}. Wrong! Guess again."}
    else
      %{
        score: socket.assigns.score + 10,
        message: "Your guess: #{guess}. CORRECT! Congratulations. Guess the next one:",
        luck_number: Enum.random(1..10)
      }
    end

    {
      :noreply,
      assign(socket, state)
    }
  end
end
