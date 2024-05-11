defmodule PentoWeb.SurveyLive do
  alias Pento.Survey
  alias PentoWeb.DemographicLive

  import PentoWeb.SurveyLive.Component

  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign_demographic}
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end
end
