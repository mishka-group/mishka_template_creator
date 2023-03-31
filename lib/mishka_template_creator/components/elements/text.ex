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
  def render(%{render_type: "call"} = assigns) do
    IO.inspect(assigns.element)
    ~H"""
    <div
      data-type="text"
      id={"text-#{@id}"}
      phx-click="aside_select_form"
      phx-value-id={"#{@id}"}
      class={@element.class}
    >
      <%= Map.get(@element, :html) || "This is a predefined text. Please click on the text to edit." %>
    </div>
    """
  end

  @impl true
  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div
      data-type="text"
      id={"text-#{@id}"}
      phx-click="select_form"
      phx-value-id={"#{@id}"}
      phx-target={@myself}
      class={@element.class}
    >
      <%= Map.get(@element, :html) || "This is a predefined text. Please click on the text to edit." %>
    </div>
    """
  end

  @impl true
  def handle_event("select_form", %{"id" => _id}, socket) do
    {:noreply, socket}
  end
end
