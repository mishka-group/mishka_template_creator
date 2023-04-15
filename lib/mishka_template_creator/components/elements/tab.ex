defmodule MishkaTemplateCreator.Components.Elements.Tab do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  use Phoenix.Component

  alias MishkaTemplateCreator.Components.Blocks.Aside
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias Phoenix.LiveView.JS

  # TODO: Add new tab and it's text
  # TODO: Tabs Title
  # TODO: Tabs Title icon
  # TODO: Tabs Title icon all style like text component
  # TODO: Tab title font size
  # TODO: Tab text all styles like text component
  # TODO: Show tab tree to manage and edit all of them with click
  # ---------------------------------------------------------------------------------------------------------------
  # TODO: Presets which are added with MishkaInstaller as a plugin, it let user select pre-prepared tabs. in V0.0.2
  %{
    "unique_id" => %{
      "children" => %{
        "unique_id-0" => %{"title" => "", "html" => "", "icon" => ""},
        "unique_id-1" => %{"title" => "", "html" => "", "icon" => ""}
      },
      "header" => %{
        "container" => "",
        "title" => "",
        "icon" => "",
        "button" => ""
      },
      "content" => "",
      "order" => ["unique_id-0", "unique_id-1"],
      "class" => "",
      "type" => "tab",
      "parent" => "section",
      "parent_id" => "unique_id"
    }
  }

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
    ~H"""
    <div
      data-type="tab"
      id={"tab-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      class={@element["class"]}
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
    >
      <.tab_header
        header={@element["header"]}
        children={sorted_list(@element["order"], @element["children"])}
      />

      <.tab_content
        content={@element["content"]}
        children={sorted_list(@element["order"], @element["children"])}
      />
    </div>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>form</div>
    """
  end

  attr(:header, :map, required: true)
  attr(:children, :list, required: false, default: [])

  def tab_header(assigns) do
    ~H"""
    <ul :if={length(@children) != 0} class={Enum.join(@header["container"], " ")}>
      <li :for={{%{id: key, data: data}, index} <- Enum.with_index(@children)} id={key}>
        <button
          class={"#{Enum.join(@header["button"], " ")} #{if index == 0, do: "border-b border-blue-500"}"}
          type="button"
          phx-click={reset_and_select(@children, key)}
          id={"button-#{key}"}
        >
          <MishkaCoreComponent.dynamic_icon
            module={data["icon"]}
            class={Enum.join(@header["icon"], " ")}
          />
          <span class={Enum.join(@header["title"], " ")}><%= data["title"] %></span>
        </button>
      </li>
    </ul>
    """
  end

  attr(:content, :list, required: true)
  attr(:children, :map, required: false, default: [])

  def tab_content(assigns) do
    ~H"""
    <div
      :for={{%{id: key, data: data}, index} <- Enum.with_index(@children)}
      id={"content-#{key}"}
      class={"#{Enum.join(@content, " ")} #{if index != 0, do: "hidden"}"}
    >
      <%= data["html"] %>
    </div>
    """
  end

  @impl true
  def handle_event("get_element_layout_id", %{"myself" => myself}, socket) do
    new_sock =
      push_event(socket, "get_element_parent_id", %{
        id: socket.assigns.element["parent_id"],
        myself: myself
      })

    {:noreply, new_sock}
  end

  def handle_event("set", %{"layout_id" => layout_id}, socket) do
    %{"parent_id" => parent_id, "type" => type} = socket.assigns.element

    send(
      self(),
      {"set",
       %{
         "id" => String.replace(socket.assigns.id, "-call", ""),
         "type" => type,
         "layout_id" => layout_id,
         "parent_id" => parent_id
       }}
    )

    {:noreply, socket}
  end

  def handle_event("validate", %{"text_component" => %{"tag" => tag}}, socket) do
    submit_status =
      Regex.match?(~r/^[A-Za-z][A-Za-z0-9-]*$/, String.trim(tag)) and
        String.length(String.trim(tag)) > 3

    case {submit_status, String.trim(tag)} do
      {true, _tag} ->
        %{
          "id" => id,
          "parent_id" => parent_id,
          "layout_id" => layout_id,
          "type" => type
        } = socket.assigns.selected_form

        params = %{
          "tag" => %{
            "id" => id,
            "parent_id" => parent_id,
            "layout_id" => layout_id,
            "tag" => String.trim(tag),
            "type" => type
          }
        }

        send(self(), {"element", params})

      _ ->
        send(self(), {"validate", %{"tag" => tag}})
    end

    {:noreply, socket}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("delete", _params, socket) do
    send(self(), {"delete", %{"delete_element" => socket.assigns.selected_form}})

    {:noreply, socket}
  end

  defp sorted_list(order, children) do
    Enum.map(order, fn key -> %{id: key, data: children[key]} end)
  end

  defp reset_and_select(js \\ %JS{}, children, id) do
    children
    |> Enum.reduce(js, fn %{id: key, data: _data}, acc ->
      acc
      |> JS.add_class("hidden", to: "#content-#{key}")
      |> JS.remove_class("border-b", to: "#button-#{key}")
      |> JS.remove_class("border-blue-500", to: "#button-#{key}")
    end)
    |> JS.remove_class("hidden", to: "#content-#{id}")
    |> JS.add_class("border-b", to: "#button-#{id}")
    |> JS.add_class("border-blue-500", to: "#button-#{id}")
  end
end
