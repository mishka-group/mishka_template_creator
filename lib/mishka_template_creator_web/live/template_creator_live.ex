defmodule MishkaTemplateCreatorWeb.TemplateCreatorLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import MishkaTemplateCreatorWeb.MishkaCoreComponent

  @impl true
  def render(assigns) do
    ~H"""
    <.dashboard
      elemens={@elemens}
      selected_block={@selected_block}
      submit={@submit}
      selected_setting={@selected_setting}
    />
    """
  end

  # TODO: create multi layout sections and store in a Genserver or ETS
  # TODO: create multisection in a layout and store them under the layout
  @impl true
  def mount(_params, _, socket) do
    new_socket =
      assign(socket, elemens: [], selected_block: nil, submit: true, selected_setting: nil)

    {:ok, new_socket}
  end

  @impl true
  def handle_event(
        "dropped_element",
        %{"index" => index, "type" => type, "parent" => parent, "parent_id" => parent_id},
        socket
      ) do
    create_element(%{type: type, index: index, parent: parent, parent_id: parent_id})
    |> update_elements(socket, parent, "create_draggable")
  end

  # Layout Events
  def handle_event("save_draft", _, socket) do
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id, "type" => "dom"}, socket) do
    {:noreply, push_event(socket, "delete", %{id: id})}
  end

  def handle_event("delete", %{"id" => id, "type" => "layout"}, socket) do
    element = delete_element(socket.assigns.elemens, id, "layout")

    new_assign =
      push_event(socket, "create_preview_helper", %{status: length(element) == 0})
      |> assign(:elemens, element)

    {:noreply, new_assign}
  end

  def handle_event("delete", %{"id" => id, "type" => "section", "parent_id" => parent_id}, socket) do
    new_assign =
      assign(socket, :elemens, delete_element(socket.assigns.elemens, id, parent_id, "section"))

    {:noreply, new_assign}
  end

  def handle_event(
        "validate_tag",
        %{"_target" => _target, "tag" => %{"tag" => tag}},
        socket
      ) do
    submit_status =
      Regex.match?(~r/^[A-Za-z][A-Za-z0-9-]*$/, String.trim(tag)) and
        String.length(String.trim(tag)) > 3

    {:noreply, assign(socket, :submit, !submit_status)}
  end

  def handle_event(
        "save_tag",
        %{"tag" => %{"tag" => tag, "type" => type, "id" => id, "parent_id" => parent_id}},
        socket
      ) do
    submit_status =
      Regex.match?(~r/^[A-Za-z][A-Za-z0-9-]*$/, String.trim(tag)) and
        String.length(String.trim(tag)) > 3

    new_socket =
      case {submit_status, String.trim(tag)} do
        {true, tag} ->
          assign(
            socket,
            elemens: add_tag(socket.assigns.elemens, id, parent_id, tag, type),
            submit: true
          )

        _ ->
          socket
      end

    {:noreply, new_socket}
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

  def handle_event("dark_mod", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("mobile_view", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  def handle_event("edit_section", %{"id" => id}, socket) do
    {:noreply, assign(socket, :selected_block, id)}
  end

  def handle_event("edit_element", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  # This is reset event
  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, selected_block: nil, selected_setting: nil)}
  end

  def handle_event("add_custom_class", %{"id" => _id, "type" => _type}, socket) do
    {:noreply, socket}
  end

  def handle_event("selected_setting", params, socket) do
    {:noreply, assign(socket, :selected_setting, params)}
  end

  def handle_event("reset_settings", _params, socket) do
    {:noreply, assign(socket, :selected_setting, nil)}
  end

  def handle_event(
        "change_order",
        %{
          "current_index" => current_index,
          "new_index" => new_index,
          "parent_id" => parent_id,
          "type" => type
        },
        socket
      ) do
    elemens =
      socket.assigns.elemens
      |> change_order(current_index, new_index, parent_id, type)

    {:noreply, assign(socket, elemens: elemens)}
  end

  @impl true
  def handle_info({"add_element_config", selected_config}, socket) do
    IO.inspect(selected_config)
    {:noreply, socket}
  end

  @impl true
  def handle_info({"delete_element_config", selected_config}, socket) do
    IO.inspect(selected_config)
    {:noreply, socket}
  end

  def update_elements(nil, socket, _, _), do: {:noreply, socket}

  def update_elements(new_element, socket, parent, event) do
    elemens =
      socket.assigns.elemens
      |> elements_reevaluation(new_element, parent)
      |> sort_elements_list()

    new_socket = assign(socket, elemens: elemens)

    push_element =
      if new_element.type not in ["layout", "section"],
        do: new_socket,
        else: push_event(new_socket, event, new_element)

    {:noreply, push_element}
  end
end
