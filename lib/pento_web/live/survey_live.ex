defmodule PentoWeb.SurveyLive do
  alias Pento.Catalog
  alias Pento.Survey
  alias PentoWeb.DemographicLive
  alias PentoWeb.RatingLive

  import PentoWeb.SurveyLive.Component

  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_demographic
     |> assign_products}
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  def handle_info({:created_rating, product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, product, product_index)}
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end

  defp assign_products(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :products, list_products(current_user))
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  def handle_rating_created(
        %{assigns: %{products: products}} = socket,
        updated_product,
        product_index
      ) do
    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(
      :products,
      List.replace_at(products, product_index, updated_product)
    )
  end

  defp list_products(user) do
    Catalog.list_products_with_user_rating(user)
  end
end
