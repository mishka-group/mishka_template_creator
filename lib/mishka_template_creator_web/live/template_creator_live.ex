defmodule MishkaTemplateCreatorWeb.TemplateCreatorLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import MishkaTemplateCreatorWeb.CoreComponents
  alias Phoenix.LiveView.JS

  def mount(_params, _, socket) do
    new_socket = assign(socket, show: false, section_id: nil)
    {:ok, new_socket}
  end

  # Test code and should be deleted
  def handle_event("change-section", _, socket) do
    {:noreply, socket}
  end

  # Layout Events
  def handle_event("save_draft", _, socket) do
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id, "type" => "dom"}, socket) do
    {:noreply, push_event(socket, "delete", %{id: id})}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    JS.push("delete", value: %{id: id, type: "dom"})
    |> hide_modal("delete_confirm")
    |> Map.get(:ops)
    |> Jason.encode!()
    |> IO.inspect()
    # after delete count childeren of content div and if is there not any element enable perview
    {:noreply, assign(socket, :section_id, id)}
  end

  def handle_event("tag", %{"id" => id}, socket) do
    {:noreply, push_event(socket, "tag", %{id: id})}
  end

  def handle_event("add_separator", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("settings", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("reset", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("dark_mod", %{"id" => id}, socket) do
    IO.inspect(id)
    {:noreply, socket}
  end
end
