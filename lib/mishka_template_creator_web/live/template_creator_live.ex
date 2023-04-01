defmodule MishkaTemplateCreatorWeb.TemplateCreatorLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import MishkaTemplateCreatorWeb.MishkaCoreComponent
  alias MishkaTemplateCreator.Data.TailwindSetting

  # TODO: create multi layout sections and store in a Genserver or ETS
  # TODO: create multisection in a layout and store them under the layout

  @impl true
  def mount(_params, _, socket) do
    if connected?(socket), do: Process.send_after(self(), :save_db, 10000)

    new_socket =
      assign(socket,
        # JSON of elements
        elements: [],
        # Selected element for section
        selected_block: nil,
        # Tag submit status to let user push data or not, can be integrated inside a live component
        submit: true,
        # This is a selected settings of an element, returns a map
        selected_setting: nil,
        # It is going to be used inside Aside component, returns component name as a map
        selected_form: nil
      )

    {:ok, new_socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.dashboard
      elements={@elements}
      selected_block={@selected_block}
      submit={@submit}
      selected_setting={@selected_setting}
      selected_form={@selected_form}
    />
    """
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
    element = delete_element(socket.assigns.elements, id, "layout")

    new_assign =
      push_event(socket, "create_preview_helper", %{status: length(element) == 0})
      |> assign(:elements, element)

    {:noreply, new_assign}
  end

  def handle_event("delete", %{"id" => id, "type" => "section", "parent_id" => parent_id}, socket) do
    new_assign =
      assign(socket, :elements, delete_element(socket.assigns.elements, id, parent_id, "section"))

    {:noreply, new_assign}
  end

  def handle_event("validate_tag", %{"tag" => %{"tag" => tag}}, socket) do
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
            elements: add_tag(socket.assigns.elements, id, parent_id, tag, type),
            submit: true
          )

        _ ->
          socket
      end

    {:noreply, new_socket}
  end

  def handle_event("add_separator", %{"id" => _id}, socket) do
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

  # This is reset event
  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, selected_block: nil, selected_setting: nil)}
  end

  def handle_event("selected_setting", params, socket) do
    {:noreply, assign(socket, :selected_setting, params)}
  end

  def handle_event("reset_settings", _params, socket) do
    {:noreply, assign(socket, :selected_setting, nil)}
  end

  def handle_event("back_to_blocks", _params, socket) do
    {:noreply, assign(socket, :selected_form, nil)}
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
    elements =
      socket.assigns.elements
      |> change_order(current_index, new_index, parent_id, type)

    {:noreply, assign(socket, elements: elements)}
  end

  @impl true
  def handle_info(
        {"add_element_config",
         %{
           "block_type" => block_type,
           "block_id" => block_id,
           "custom_classes" => custom_classes,
           "parent_id" => parent_id
         }},
        socket
      ) do
    new_assign =
      assign(
        socket,
        elements:
          add_element_config(
            socket.assigns.elements,
            block_id,
            parent_id,
            custom_classes,
            block_type,
            :string_classes
          )
      )

    {:noreply, new_assign}
  end

  def handle_info({"add_element_config", selected_config}, socket) do
    %{
      block_id: block_id,
      block_type: block_type,
      config: config,
      extra_config: extra,
      parent_id: parent_id
    } = selected_config

    new_assign =
      assign(
        socket,
        elements:
          add_element_config(
            socket.assigns.elements,
            block_id,
            parent_id,
            TailwindSetting.create_class(extra, config),
            block_type
          )
      )

    {:noreply, new_assign}
  end

  def handle_info({"delete_element_config", selected_config}, socket) do
    %{block_id: block_id, block_type: block_type, config: config, parent_id: parent_id} =
      selected_config

    new_assign =
      assign(
        socket,
        elements:
          delete_element_config(socket.assigns.elements, block_id, parent_id, config, block_type)
      )

    {:noreply, new_assign}
  end

  def handle_info({"set_element_form", params}, socket) do
    {:noreply, assign(socket, :selected_form, params)}
  end

  def handle_info(:save_db, socket) do
    # TODO: it should be saved in DB
    Process.send_after(self(), :save_db, 10000)
    {:noreply, socket}
  end

  def update_elements(nil, socket, _, _), do: {:noreply, socket}

  def update_elements(new_element, socket, parent, event) do
    elements =
      socket.assigns.elements
      |> elements_reevaluation(new_element, parent)
      |> sort_elements_list()

    new_socket = assign(socket, elements: elements)

    push_element =
      if new_element.type not in ["layout", "section"],
        do: new_socket,
        else: push_event(new_socket, event, new_element)

    {:noreply, push_element}
  end
end
