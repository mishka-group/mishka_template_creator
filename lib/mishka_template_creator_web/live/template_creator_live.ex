defmodule MishkaTemplateCreatorWeb.TemplateCreatorLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import MishkaTemplateCreatorWeb.CoreComponents
  alias Phoenix.LiveView.JS

  def mount(_params, _, socket) do
    {:ok, socket}
  end

  def handle_event("change-section", _, socket) do
    IO.inspect("This is we have")
    {:noreply, socket}
  end
end
