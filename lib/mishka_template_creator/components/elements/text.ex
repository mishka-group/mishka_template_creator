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
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      class={@element.class}
    >
      <%= Map.get(@element, :html) || "This is a predefined text. Please click on the text to edit." %>
    </div>
    """
  end

  @impl true
  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div data-type="text" id={"text-#{@id}"} class={@element.class}>
      <%= Map.get(@element, :html) || "This is a predefined text. Please click on the text to edit." %>
    </div>
    """
  end

  @impl true
  def handle_event("get_element_layout_id", %{"myself" => myself}, socket) do
    # TODO: Get parent id of section (layout) by Hook
    # %{
    #   children: [],
    #   class: ["text-black", "w-full", "p-2"],
    #   id: "36ca0e15-910a-44d9-a6f8-fc68a7a422b6",
    #   index: 0,
    #   parent: "section",
    #   parent_id: "928e8036-bc49-4d8e-8fba-0ec155874916",
    #   type: "text"
    # }

    # {element_id, section_id: parent_id, layout_id, type}
    new_sock =
      push_event(socket, "get_element_parent_id", %{
        id: socket.assigns.element.parent_id,
        myself: myself
      })

    {:noreply, new_sock}
  end

  def handle_event("set_element_form", %{"layout_id" => layout_id}, socket) do
    %{parent_id: section_id, id: element_id, type: element_type} = socket.assigns.element

    send(
      self(),
      {"set_element_form",
       %{
         element_id: element_id,
         element_type: element_type,
         layout_id: layout_id,
         section_id: section_id
       }}
    )

    {:noreply, socket}
  end
end
