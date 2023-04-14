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
        # JSON of elements, it should be loaded from database or draft ETS if exists
        elements: %{"id" => Ecto.UUID.generate(), "order" => [], "children" => %{}},
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

  # Handle Events
  @impl true
  def handle_event("create", params, socket) do
    push_element =
      case create_and_reevaluate_element(socket.assigns.elements, params) do
        nil ->
          socket

        {new_element, id} ->
          new_socket =
            socket
            |> assign(:elements, new_element)

          if params["type"] not in ["layout", "section"],
            do: new_socket,
            else: push_event(new_socket, "create_draggable", %{id: id})
      end

    {:noreply, push_element}
  end

  def handle_event("delete", params, socket) do
    element = delete_element(socket.assigns.elements, params)

    new_assign =
      socket
      |> assign(elements: element, selected_form: nil)
      |> push_event("create_preview_helper", %{status: length(Map.keys(element["children"])) == 0})
      |> push_event("redefine_blocks_drag_and_drop", %{})

    {:noreply, new_assign}
  end

  def handle_event("validate", %{"tag" => %{"tag" => tag}}, socket) do
    submit_status =
      Regex.match?(~r/^[A-Za-z][A-Za-z0-9-]*$/, String.trim(tag)) and
        String.length(String.trim(tag)) > 3

    {:noreply, assign(socket, :submit, !submit_status)}
  end

  # def handle_event("class", params, socket) do
  # end

  def handle_event("element", %{"tag" => params}, socket) do
    submit_status =
      Regex.match?(~r/^[A-Za-z][A-Za-z0-9-]*$/, String.trim(params["tag"])) and
        String.length(String.trim(params["tag"])) > 3

    new_socket =
      case {submit_status, String.trim(params["tag"])} do
        {true, tag} ->
          assign(
            socket,
            elements:
              socket.assigns.elements
              |> add_tag(Map.merge(params, %{"tag" => tag})),
            submit: true
          )

        _ ->
          socket
      end

    {:noreply, new_socket}
  end

  def handle_event("back", _params, socket) do
    new_socket =
      assign(socket, :selected_form, nil)
      |> push_event("redefine_blocks_drag_and_drop", %{})

    {:noreply, new_socket}
  end

  def handle_event("reset", %{"type" => "setting"}, socket) do
    {:noreply, assign(socket, selected_setting: nil)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, selected_block: nil, selected_setting: nil)}
  end

  def handle_event(
        "order",
        %{
          "id" => id,
          "new_index" => index,
          "parent_id" => parent_id,
          "type" => _type,
          "parent_type" => parent_type
        },
        socket
      ) do
    elements =
      socket.assigns.elements
      |> change_order(id, index, parent_id, parent_type)

    {:noreply, assign(socket, elements: elements)}
  end

  def handle_event("set", %{"id" => id, "type" => "section"}, socket) do
    selected_block = if socket.assigns.selected_block == id, do: nil, else: id
    {:noreply, assign(socket, :selected_block, selected_block)}
  end

  def handle_event("set", %{"type" => "setting"} = params, socket) do
    {:noreply, assign(socket, :selected_setting, params)}
  end

  def handle_event("action", %{"type" => "save_draft"}, socket) do
    {:noreply, socket}
  end

  def handle_event("view", %{"type" => "add_separator"}, socket) do
    {:noreply, socket}
  end

  def handle_event("view", %{"type" => "dark_mod"}, socket) do
    {:noreply, socket}
  end

  def handle_event("view", %{"type" => "mobile_view"}, socket) do
    {:noreply, socket}
  end

  @impl true
  # Handle Info
  # def handle_info({"create", params}, socket) do
  # end

  def handle_info({"delete", %{"delete_class" => selected_config}}, socket) do
    %{
      "id" => id,
      "type" => type,
      "class" => class,
      "parent_id" => parent_id
    } = selected_config

    new_assign =
      assign(
        socket,
        elements: delete_class(socket.assigns.elements, id, parent_id, class, type)
      )

    {:noreply, new_assign}
  end

  def handle_info({"delete", %{"delete_element" => params}}, socket) do
    element = delete_element(socket.assigns.elements, params)

    new_assign =
      socket
      |> assign(elements: element, selected_form: nil)
      |> push_event("create_preview_helper", %{status: length(Map.keys(element["children"])) == 0})
      |> push_event("redefine_blocks_drag_and_drop", %{})

    {:noreply, new_assign}
  end

  def handle_info({"validate", %{"tag" => tag}}, socket) do
    submit_status =
      Regex.match?(~r/^[A-Za-z][A-Za-z0-9-]*$/, String.trim(tag)) and
        String.length(String.trim(tag)) > 3

    {:noreply, assign(socket, :submit, !submit_status)}
  end

  # def handle_info({"class", params}, socket) do
  # end

  def handle_info({"element", %{"tag" => params}}, socket) do
    submit_status =
      Regex.match?(~r/^[A-Za-z][A-Za-z0-9-]*$/, params["tag"]) and
        String.length(params["tag"]) > 3

    new_socket =
      if submit_status,
        do: assign(socket, elements: add_tag(socket.assigns.elements, params), submit: false),
        else: socket

    {:noreply, new_socket}
  end

  def handle_info(
        {"element", %{"update_class" => %{"action" => action} = params}},
        socket
      ) do
    elements =
      socket.assigns.elements
      |> add_class(params["id"], params["parent_id"], params["class"], params["type"], action)

    {:noreply, assign(socket, elements: elements)}
  end

  def handle_info({"element", %{"config_selector" => selected_config}}, socket) do
    %{
      "id" => id,
      "type" => type,
      "class" => class,
      "extra_config" => extra,
      "parent_id" => parent_id
    } = selected_config

    new_assign =
      assign(
        socket,
        elements:
          socket.assigns.elements
          |> add_class(id, parent_id, TailwindSetting.create_class(extra, class), type, :normal)
      )

    {:noreply, new_assign}
  end

  def handle_info({"element", %{"update_parame" => update_parame}}, socket) do
    elements =
      socket.assigns.elements
      |> add_param(
        update_parame["id"],
        update_parame["parent_id"],
        %{"#{update_parame["key"]}" => update_parame["value"]},
        update_parame["type"]
      )

    {:noreply, assign(socket, elements: elements)}
  end

  # def handle_info({"reset", params}, socket) do
  # end

  # def handle_info({"order", params}, socket) do
  # end

  def handle_info({"set", params}, socket) do
    {:noreply, assign(socket, :selected_form, params)}
  end

  def handle_info(:save_db, socket) do
    # TODO: it should be saved in DB
    Process.send_after(self(), :save_db, 10000)
    {:noreply, socket}
  end
end
