defmodule MishkaTemplateCreator.Components.Elements.Tab do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias MishkaTemplateCreator.Components.Layout.Aside
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias MishkaTemplateCreator.Components.Blocks.Tag
  alias MishkaTemplateCreator.Components.Blocks.Icon
  alias MishkaTemplateCreator.Components.Blocks.Color
  alias MishkaTemplateCreator.Components.Elements.Text

  # ---------------------------------------------------------------------------------------------------------------
  # TODO: Presets which are added with MishkaInstaller as a plugin, it let user select pre-prepared tabs. in V0.0.2
  # ---------------------------------------------------------------------------------------------------------------
  @impl true
  def update(
        %{
          id: id,
          render_type: render_type,
          selected_form: selected_form,
          elements: elements,
          submit: submit
        },
        socket
      ) do
    element =
      MishkaCoreComponent.find_element(
        elements,
        selected_form["id"],
        selected_form["parent_id"],
        selected_form["layout_id"],
        selected_form["type"]
      )

    new_socket =
      assign(socket,
        id: id,
        render_type: render_type,
        selected_form: selected_form,
        element: element,
        submit: submit
      )

    {:ok, new_socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
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
      dir={@element["direction"] || "LTR"}
    >
      <.tab_header
        header={@element["header"]}
        children={MishkaCoreComponent.sorted_list_by_order(@element["order"], @element["children"])}
      />

      <.tab_content
        content={@element["content"]}
        children={MishkaCoreComponent.sorted_list_by_order(@element["order"], @element["children"])}
      />
    </div>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"tab-#{@id}"}>
        <div class="w-full text-sm font-medium text-center text-gray-500 border-b border-gray-200 items-center mx-auto mb-4">
          <ul class="w-full flex flex-row -mb-px justify-center items-center">
            <li>
              <a
                href="#"
                class="inline-block p-4 text-blue-600 border-b-2 border-blue-600 rounded-t-lg"
                aria-current="page"
              >
                Quick edit
              </a>
            </li>
            <li>
              <a
                href="#"
                class="inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300 relative"
              >
                Advanced edit
                <div class="absolute inline-flex items-center justify-center text-whitebg-blue-100 text-blue-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded border border-blue-400 -top-2 -right-2">
                  Soon
                </div>
              </a>
            </li>
            <li>
              <a
                href="#"
                class="inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300 relative"
              >
                Presets
                <div class="absolute inline-flex items-center justify-center text-whitebg-pink-100 text-pink-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded border border-pink-400 -top-2 -right-2">
                  Pro
                </div>
              </a>
            </li>
          </ul>
        </div>

        <Aside.aside_accordion
          id={"tab-#{@id}"}
          title="Tab Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <:before_title_block>
            <Heroicons.plus class="w-5 h-5 cursor-pointer" phx-click="add" phx-target={@myself} />
          </:before_title_block>
          <div class="flex flex-col w-full pb-5 gap-4 pt-2">
            <%= for {%{id: key, data: data}, index} <- Enum.with_index(MishkaCoreComponent.sorted_list_by_order(@element["order"], @element["children"])) do %>
              <div id={"title-#{key}"}>
                <div
                  class="flex flex-row w-full justify-start items-start gap-2 cursor-pointer"
                  phx-click={
                    JS.toggle(to: "#tree-#{key}")
                    |> JS.hide(to: "#form-icon-#{key}")
                    |> JS.hide(to: "#form-text-#{key}")
                    |> JS.hide(to: "#form-title-#{key}")
                  }
                >
                  <Heroicons.rectangle_stack class="w-6 h-6" />
                  <span class="text-base font-bold select-none">
                    <%= data["title"] %>
                  </span>
                </div>
              </div>

              <div
                class={"#{if index != 0, do: "hidden"} border-b border-gray-300 pb-4 pt-2"}
                id={"tree-#{key}"}
              >
                <.tab_form
                  :for={type <- ["title", "text", "icon"]}
                  data={data}
                  type={type}
                  key={key}
                  myself={@myself}
                  header={@element["header"]}
                  content={@element["content"]}
                />
                <div class="flex flex-row w-full pl-5 gap-2 justify-between items-center mx-auto">
                  <div
                    class="flex flex-row w-full justify-start items-start gap-2 cursor-pointer"
                    phx-click={
                      JS.toggle(to: "#form-title-#{key}")
                      |> JS.hide(to: "#form-icon-#{key}")
                      |> JS.hide(to: "#form-text-#{key}")
                    }
                  >
                    <Heroicons.pencil_square class="w-5 h-5" />
                    <span class="text-base select-none">Title</span>
                  </div>
                  <div
                    class="flex flex-row w-full justify-start items-start gap-2 cursor-pointer"
                    phx-click={
                      JS.toggle(to: "#form-text-#{key}")
                      |> JS.hide(to: "#form-icon-#{key}")
                      |> JS.hide(to: "#form-title-#{key}")
                    }
                  >
                    <Heroicons.bars_3_bottom_left class="w-5 h-5" />
                    <span class="text-base select-none">Text</span>
                  </div>
                  <div
                    class="flex flex-row w-full justify-start items-start gap-2 cursor-pointer"
                    phx-click={
                      JS.toggle(to: "#form-icon-#{key}")
                      |> JS.hide(to: "#form-text-#{key}")
                      |> JS.hide(to: "#form-title-#{key}")
                    }
                  >
                    <Heroicons.computer_desktop class="w-5 h-5" />
                    <span class="text-base select-none">Icon</span>
                  </div>
                  <div
                    class="flex flex-row w-full justify-start items-start gap-2 cursor-pointer"
                    phx-click="delete"
                    phx-value-id={key}
                    phx-value-type="tab"
                    phx-target={@myself}
                  >
                    <Heroicons.trash class="w-5 h-5 text-red-600" />
                    <span class="text-base select-none">Delete</span>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"tab-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"tab-#{@id}"} title="Alignment" open={false}>
            <Text.alignment_selector myself={@myself} />
            <Text.direction_selector myself={@myself} />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"tab-#{@id}"} title="Font Style" open={false}>
            <Text.font_style myself={@myself} classes={@element["class"]} as={:public_tab_font_style} />
            <Color.select
              myself={@myself}
              event_name="public_tab_font_style"
              classes={@element["class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"tab-#{@id}"} title="Custom Tag name" open={false}>
            <div class="flex flex-col w-full items-center justify-center pb-5">
              <Tag.input_tag myself={@myself} value={@element["tag"]} submit={@submit} id={@id} />
            </div>
          </Aside.aside_accordion>

          <div class="flex flex-row w-full justify-center items-center gap-3 pb-10 mt-5">
            <.button
              phx-click="delete"
              phx-target={@myself}
              class="w-24 !bg-white border border-gray-300 shadow-sm !text-red-600 hover:!bg-gray-300 hover:text-gray-400 !rounded-md"
            >
              Delete
            </.button>
            <.button
              phx-click="reset"
              phx-target={@myself}
              class="w-24 !bg-white border border-gray-300 shadow-sm !text-black hover:!bg-gray-300 hover:text-gray-400 !rounded-md"
            >
              Reset
            </.button>
          </div>
        </Aside.aside_accordion>
      </Aside.aside_settings>
    </div>
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
          <Icon.dynamic module={data["icon"]} class={Enum.join(@header["icon"], " ")} />
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
    <p :if={length(@children) == 0} class={Enum.join(@content, " ") <> " text-center"}>
      There is no Tab to show! Click here
    </p>

    <div
      :for={{%{id: key, data: data}, index} <- Enum.with_index(@children)}
      id={"content-#{key}"}
      class={"#{Enum.join(@content, " ")} #{if index != 0, do: "hidden"}"}
    >
      <%= data["html"] %>
    </div>
    """
  end

  attr(:data, :map, required: true)
  attr(:key, :string, required: true)
  attr(:type, :string, required: true)
  attr(:myself, :integer, required: true)
  attr(:content, :string, required: true)
  attr(:header, :map, required: true)

  defp tab_form(%{type: "title"} = assigns) do
    ~H"""
    <div id={"form-title-#{@key}"} class="hidden">
      <MishkaCoreComponent.custom_simple_form
        :let={f}
        for={%{}}
        as={:tab_title}
        phx-submit="element"
        phx-target={@myself}
        class="flex flex-row w-full justify-between items-center px-5 gap-2 mx-auto mt-2 mb-5 pb-2"
      >
        <%= text_input(f, :title,
          class:
            "block w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
          value: @data["title"],
          id: "tab_title_title-#{@key}"
        ) %>

        <.input field={f[:id]} type="hidden" value={@key} id={"tab_title_id-#{@key}"} />

        <button
          type="submit"
          class="px-4 py-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700"
        >
          Save
        </button>
      </MishkaCoreComponent.custom_simple_form>

      <Aside.aside_accordion id={"title-#{@key}"} title="Font Style">
        <Text.font_style
          myself={@myself}
          classes={@header["title"]}
          as={:tab_title_font_style}
          id_input={@key}
        />
        <Color.select myself={@myself} event_name="tab_title_font_style" classes={@header["title"]} />
      </Aside.aside_accordion>
    </div>
    """
  end

  defp tab_form(%{type: "text"} = assigns) do
    ~H"""
    <div id={"form-text-#{@key}"} class="hidden">
      <MishkaCoreComponent.custom_simple_form
        :let={f}
        for={%{}}
        as={:tab_text}
        phx-submit="element"
        phx-target={@myself}
        class="flex flex-col w-full px-5 gap-2 mx-auto mt-2 mb-5 justify-center items-center"
      >
        <%= textarea(f, :html,
          class:
            "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
          value: @data["html"],
          id: "tab_text-#{@key}",
          rows: "4"
        ) %>

        <.input field={f[:id]} type="hidden" value={@key} id={"tab_text_id-#{@key}"} />

        <button
          type="submit"
          class="px-4 py-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700"
        >
          Save
        </button>
      </MishkaCoreComponent.custom_simple_form>
      <Aside.aside_accordion id={"title-#{@key}"} title="Content Font Style">
        <Text.font_style
          myself={@myself}
          classes={@content}
          as={:tab_text_font_style}
          id_input={@key}
        />
        <Color.select myself={@myself} event_name="tab_content_font_style" classes={@content} />
      </Aside.aside_accordion>
      <Aside.aside_accordion id={"tab-#{@key}"} title="Content Border Radius">
        <div class="flex flex-col w-full items-center justify-center">
          <ul class="flex flex-row mx-auto text-md border-gray-400 py-5 text-gray-600">
            <li
              class={"#{create_border_radius(@content, "rounded-none")} px-3 py-1 border border-gray-300 rounded-l-md border-r-0 hover:bg-gray-200 cursor-pointer"}
              phx-click="border_radius"
              phx-value-type="rounded-none"
              phx-target={@myself}
            >
              None
            </li>
            <li
              class={"#{create_border_radius(@content, "rounded-sm")} px-3 py-1 border border-gray-300 hover:bg-gray-200 cursor-pointer"}
              phx-click="border_radius"
              phx-value-type="rounded-sm"
              phx-target={@myself}
            >
              SM
            </li>
            <li
              class={"#{create_border_radius(@content, "rounded-md")} px-3 py-1 border border-gray-300 border-l-0 hover:bg-gray-200 cursor-pointer"}
              phx-click="border_radius"
              phx-value-type="rounded-md"
              phx-target={@myself}
            >
              MD
            </li>
            <li
              class={"#{create_border_radius(@content, "rounded-lg")} px-3 py-1 border border-gray-300 rounded-r-md border-l-0 hover:bg-gray-200 cursor-pointer"}
              phx-click="border_radius"
              phx-value-type="rounded-lg"
              phx-target={@myself}
            >
              LG
            </li>
          </ul>
        </div>
      </Aside.aside_accordion>
      <Aside.aside_accordion id={"text-#{@key}"} title="Content Background Color">
        <Color.select
          myself={@myself}
          event_name="tab_content_background"
          type="bg"
          classes={@content}
        />
      </Aside.aside_accordion>
    </div>
    """
  end

  defp tab_form(%{type: "icon"} = assigns) do
    ~H"""
    <div id={"form-icon-#{@key}"} class="hidden">
      <p class="w-full font-bold text-sm pb-5 border-b border-gray-300 mb-5">Select Tab Icon:</p>
      <div class="px-5 pb-3">
        <Icon.select
          selected={String.replace(@data["icon"], "Heroicons.", "")}
          myself={@myself}
          block_id={@key}
        />
      </div>

      <Aside.aside_accordion id={"icon-#{@key}"} title="Font Style">
        <Icon.select_size
          myself={@myself}
          classes={@header["icon"]}
          as={:tab_icon_style}
          id_input={@key}
          id={@key}
        />
        <Color.select myself={@myself} event_name="tab_icon_font_style" classes={@header["icon"]} />
      </Aside.aside_accordion>
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

  def handle_event("validate", %{"public_tag" => %{"tag" => tag}}, socket) do
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

  def handle_event("text_direction", %{"type" => type}, socket) when type in ["RTL", "LTR"] do
    send(
      self(),
      {"element",
       %{
         "update_parame" =>
           %{
             "key" => "direction",
             "value" => type
           }
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("text_alignment", %{"type" => type}, socket)
      when type in ["start", "center", "end", "justify"] do
    text_aligns =
      TailwindSetting.get_form_options("typography", "text-align", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["class"], &(&1 in text_aligns)) ++ ["text-#{type}"]

    send(
      self(),
      {"element",
       %{
         "update_class" =>
           %{
             "class" => Enum.join(class, " "),
             "action" => :string_classes
           }
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"public_tab_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class = Text.edit_font_style_class(socket.assigns.element["class"], font_size, font)

    send(
      self(),
      {"element",
       %{
         "update_class" =>
           %{"class" => Enum.join(class, " "), "action" => :string_classes}
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"tab_title_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class = Text.edit_font_style_class(socket.assigns.element["header"]["title"], font_size, font)

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "title" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"tab_text_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class = Text.edit_font_style_class(socket.assigns.element["content"], font_size, font)

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"tab_icon_style" => %{"height" => height, "width" => width}},
        socket
      ) do
    class = Icon.edit_icon_size(socket.assigns.element["header"]["icon"], [width, height])

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "icon" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("tab_title_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["header"]["title"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "title" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("tab_content_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["content"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("border_radius", %{"type" => type}, socket) do
    borders = TailwindSetting.get_form_options("borders", "border-radius", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["content"], &(&1 in borders)) ++ [type]

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("tab_content_background", %{"color" => color}, socket) do
    bg_colors =
      TailwindSetting.get_form_options("backgrounds", "background-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["content"], &(&1 in bg_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("tab_icon_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["header"]["icon"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "icon" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("public_tab_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["class"], &(&1 in text_colors)) ++ [color]

    send(
      self(),
      {"element",
       %{
         "update_class" =>
           %{
             "class" => Enum.join(class, " "),
             "action" => :string_classes
           }
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("add", _params, socket) do
    unique_id = Ecto.UUID.generate()

    updated =
      socket.assigns.element
      |> update_in(["children"], fn selected_element ->
        Map.merge(selected_element, %{
          "#{unique_id}" => %{
            "title" => "New Title",
            "html" =>
              "This is some placeholder content the tab's associated content. for changing the data of this tab please click here.",
            "icon" => "Heroicons.inbox_stack"
          }
        })
      end)
      |> Map.merge(%{"order" => socket.assigns.element["order"] ++ [unique_id]})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("reset", _params, socket) do
    send(
      self(),
      {"element",
       %{
         "update_parame" =>
           TailwindSetting.default_element("tab")
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id, "type" => "tab"}, socket) do
    {_, elements} = pop_in(socket.assigns.element, ["children", id])

    updated =
      elements
      |> Map.merge(%{"order" => Enum.reject(socket.assigns.element["order"], &(&1 == id))})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})
    {:noreply, socket}
  end

  def handle_event("delete", _params, socket) do
    send(self(), {"delete", %{"delete_element" => socket.assigns.selected_form}})

    {:noreply, socket}
  end

  def handle_event("element", %{"tab_title" => %{"id" => id, "title" => title}}, socket) do
    updated =
      socket.assigns.element
      |> update_in(["children", id], fn selected_element ->
        Map.merge(selected_element, %{"title" => title})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("element", %{"tab_text" => %{"id" => id, "html" => html}}, socket) do
    updated =
      socket.assigns.element
      |> update_in(["children", id], fn selected_element ->
        Map.merge(selected_element, %{"html" => html})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("select_icon", %{"name" => name, "block-id" => id}, socket) do
    updated =
      socket.assigns.element
      |> update_in(["children", id], fn selected_element ->
        Map.merge(selected_element, %{"icon" => "Heroicons.#{name}"})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  # Based on https://elixirforum.com/t/does-not-liveview-js-work-in-a-loop/55295/2
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

  defp create_border_radius(classes, type, bg_color \\ "") do
    Enum.find(classes, &(&1 == type))
    |> case do
      nil -> bg_color
      _ -> "bg-gray-300"
    end
  end
end
