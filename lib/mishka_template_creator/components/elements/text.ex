defmodule MishkaTemplateCreator.Components.Elements.Text do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      data-type="text"
      id={"text-#{@id}"}
      phx-click="edit_element"
      phx-value-id={"#{@id}"}
      phx-target={@myself}
      class={@element.class}
    >
      <%= Map.get(@element, :html) || "This is a predefined text. Please click on the text to edit." %>
    </div>
    """
  end

  @impl true
  def handle_event("edit_element", %{"id" => _id}, socket) do
    {:noreply, socket}
  end
end
