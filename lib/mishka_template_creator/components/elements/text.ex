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
    <p
      data-type="text"
      id={"text-#{@id}"}
      phx-click="edit_element"
      phx-value-id={"#{@id}"}
      phx-target={@myself}
    >
      text
    </p>
    """
  end

  @impl true
  def handle_event("edit_element", %{"id" => id}, socket) do
    IO.inspect("we are here #{id}")
    {:noreply, socket}
  end
end
