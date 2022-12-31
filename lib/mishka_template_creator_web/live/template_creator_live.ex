defmodule MishkaTemplateCreatorWeb.TemplateCreatorLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import MishkaTemplateCreatorWeb.CoreComponents
  alias Phoenix.LiveView.JS

  def mount(_params, _, socket) do
    {:ok, socket}
  end

  # Test code and should be deleted
  def handle_event("change-section", _, socket) do
    IO.inspect("This is we have")
    {:noreply, socket}
  end

  # Layout Events
  def handle_event("save_draft", _, socket) do
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("duplicate", %{"id" => _id}, socket) do
    {:noreply, socket}
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

  def handle_event("dark_mod", %{"id" => _id}, socket) do
    IO.inspect("dark mod")
    {:noreply, socket}
  end
end
