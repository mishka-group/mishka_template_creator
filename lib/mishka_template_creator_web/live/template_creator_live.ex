defmodule MishkaTemplateCreatorWeb.TemplateCreatorLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import MishkaTemplateCreatorWeb.CoreComponents
  alias Phoenix.LiveView.JS
  import MishkaTemplateCreatorWeb.MishkaCoreComponent

  # TODO: create multi layout sections and store in a Genserver or ETS
  # TODO: create multisection in a layout and store them under the layout
  # TODO: Define some rules no to allow drag a layout in a section
  # TODO: Define some rules not to allow drag another element in to empty space or layout without creating sections
  # TODO: delete preView when on dragg
  def mount(_params, _, socket) do
    new_socket = assign(socket, elemens: [])
    {:ok, new_socket}
  end

  # Test code and should be deleted
  def handle_event(
        "dropped_element",
        %{"index" => index, "type" => type, "parent" => parent, "parent_id" => parent_id},
        socket
      ) do
    create_element(%{type: type, index: index, parent: parent, parent_id: parent_id})
    |> update_elements(socket, parent)
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

  def handle_event("mobile_view", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def update_elements(nil, socket), do: {:noreply, socket}

  def update_elements(new_element, socket, parent, event \\ "create_draggable") do
    elemens =
      socket.assigns.elemens
      |> elements_reevaluation(new_element, parent)

    new_socket = assign(socket, elemens: elemens)

    {:noreply, push_event(new_socket, event, new_element)}
  end
end

# <.modal
#   id="delete_confirm"
#   on_confirm={
#     JS.push("delete", value: %{id: @section_id, type: "dom"})
#     |> hide_modal("delete_confirm")
#   }
# >
#   Are you sure?
#   <:confirm>OK</:confirm>
#   <:cancel>Cancel</:cancel>
# </.modal>
