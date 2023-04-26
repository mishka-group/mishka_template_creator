defmodule MishkaTemplateCreator.Components.Elements.Button do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  use Phoenix.Component

  alias MishkaTemplateCreator.Components.Layout.Aside
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias MishkaTemplateCreator.Components.Blocks.Tag
  alias MishkaTemplateCreator.Components.Blocks.Icon
  alias MishkaTemplateCreator.Components.Blocks.Color
  alias MishkaTemplateCreator.Components.Elements.Text

  @common_style %{
    "blue" => [
      "text-white",
      "rounded-lg",
      "bg-blue-700",
      "hover:bg-blue-800",
      "px-5",
      "py-2.5",
      "text-center",
      "inline-flex",
      "items-center",
      "font-medium",
      "mr-2",
      "mb-2",
      "justify-center"
    ],
    "light" => [
      "bg-white",
      "rounded-lg",
      "px-5",
      "py-2.5",
      "text-center",
      "inline-flex",
      "items-center",
      "font-medium",
      "mr-2",
      "mb-2",
      "border",
      "border-gray-200",
      "text-gray-900",
      "focus:outline-none",
      "hover:bg-gray-100",
      "hover:text-blue-700",
      "justify-center"
    ],
    "dark" => [
      "bg-gray-800",
      "hover:bg-gray-900",
      "text-white",
      "rounded-lg",
      "px-5",
      "py-2.5",
      "text-center",
      "inline-flex",
      "items-center",
      "font-medium",
      "mr-2",
      "mb-2",
      "justify-center"
    ],
    "green" => [
      "text-white",
      "bg-green-700",
      "hover:bg-green-800",
      "rounded-lg",
      "px-5",
      "py-2.5",
      "text-center",
      "inline-flex",
      "items-center",
      "font-medium",
      "mr-2",
      "mb-2",
      "justify-center"
    ],
    "red" => [
      "text-white",
      "bg-red-700",
      "hover:bg-red-800",
      "rounded-lg",
      "px-5",
      "py-2.5",
      "text-center",
      "inline-flex",
      "items-center",
      "font-medium",
      "mr-2",
      "mb-2",
      "justify-center"
    ],
    "yellow" => [
      "bg-yellow-400",
      "hover:bg-yellow-500",
      "rounded-lg",
      "px-5",
      "py-2.5",
      "text-center",
      "inline-flex",
      "items-center",
      "font-medium",
      "mr-2",
      "mb-2",
      "text-white",
      "justify-center"
    ]
  }

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
        submit: submit,
        common_style: @common_style
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
      data-type="button"
      id={"button-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      class={@element["class"]}
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      dir={@element["direction"] || "LTR"}
    >
      <a href="#" class={Enum.join(@element["button_class"], " ")}>
        <Icon.dynamic
          :if={!is_nil(@element["icon"]) and @element["icon"] != ""}
          module={@element["icon"]}
          class={Enum.join(@element["icon_class"], " ")}
        />
        <span><%= @element["title"] %></span>
      </a>
    </div>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"button-#{@id}"}>
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
          id={"button-#{@id}"}
          title="Button Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <MishkaCoreComponent.custom_simple_form
            :let={f}
            for={%{}}
            as={:button_component}
            phx-submit="edit"
            phx-target={@myself}
            class="flex flex-col w-full justify-start gap-2"
          >
            <div class="flex flex-col gap-2 w-full my-5">
              <span class="font-bold text-sm">Title:</span>
              <%= text_input(f, :title,
                class:
                  "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                placeholder: "Change button name",
                value: @element["title"],
                id: "input-title-#{@id}"
              ) %>
            </div>

            <div class="flex flex-col gap-2 w-full">
              <span class="font-bold text-sm">Hyperlink:</span>
              <%= text_input(f, :hyperlink,
                class:
                  "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                placeholder: "Change button hyperlink",
                value: @element["hyperlink"],
                id: "input-hyperlink-#{@id}"
              ) %>
            </div>

            <div class="flex flex-row gap-2 w-full my-5">
              <div class="flex flex-col gap-2 w-full">
                <span class="font-bold text-sm">Target:</span>
                <%= select(
                  f,
                  :target,
                  [
                    None: "none",
                    "New Window or Tab": "_blank",
                    "Current Window": "_self",
                    "Parent Window": "_parent",
                    "Top Frame": "_top"
                  ],
                  selected: @element["target"],
                  class:
                    "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2",
                  id: "select-target-#{@id}"
                ) %>
              </div>

              <div class="flex flex-col gap-2 w-full">
                <span class="font-bold text-sm">Nofollow:</span>
                <%= select(f, :nofollow, [true, false],
                  selected: @element["nofollow"],
                  class:
                    "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2",
                  id: "select-nofollow-#{@id}"
                ) %>
              </div>
            </div>

            <:actions>
              <div class="flex flex-row justify-center items-center w-full">
                <.button class="w-24">Save</.button>
              </div>
            </:actions>
          </MishkaCoreComponent.custom_simple_form>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"button-#{@id}"}
          title="Common Styles"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <div class="grid grid-cols-3 gap-2 w-full my-5 pt-2 items-center">
            <button
              :for={{key, classes} <- @common_style}
              class={classes}
              phx-click="common_style"
              phx-value-type={key}
              phx-target={@myself}
            >
              <Heroicons.server_stack class={Enum.join(@element["icon_class"], " ")} />
              <span><%= String.upcase(key) %></span>
            </button>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"button-#{@id}"}
          title="Icon Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
          open={false}
        >
          <Icon.select
            selected={String.replace(@element["icon"], "Heroicons.", "")}
            myself={@myself}
            block_id={@id}
          />

          <Icon.select_size
            myself={@myself}
            classes={@element["icon_class"]}
            as={:button_icon_style}
            id_input={@id}
          />
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"button-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"button-#{@id}"} title="Alignment" open={false}>
            <Text.alignment_selector myself={@myself} />
            <Text.direction_selector myself={@myself} />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"button-#{@id}"} title="Font and Button Style" open={false}>
            <Text.font_style
              myself={@myself}
              classes={@element["class"]}
              as={:public_button_font_style}
              id={@id}
            />
            <Color.select
              myself={@myself}
              event_name="public_button_font_style"
              classes={@element["class"]}
            />

            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              event_name="button_font_style"
              classes={@element["button_class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"button-#{@id}"} title="Custom Tag name" open={false}>
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

  def handle_event("edit", %{"button_component" => params}, socket) do
    send(
      self(),
      {"element",
       %{
         "update_parame" =>
           Map.merge(socket.assigns.element, params)
           |> Map.merge(socket.assigns.selected_form)
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
        %{"public_button_font_style" => %{"font" => font, "font_size" => font_size}},
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

  def handle_event("public_button_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["class"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("button_font_style", %{"color" => color}, socket) do
    bg_colors =
      TailwindSetting.get_form_options("backgrounds", "background-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["button_class"], &(&1 in bg_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"button_class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("common_style", %{"type" => type}, socket) do
    updated =
      socket.assigns.element
      |> Map.merge(%{"button_class" => @common_style[type]})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("select_icon", %{"name" => name}, socket) do
    updated =
      socket.assigns.element
      |> Map.merge(%{"icon" => "Heroicons.#{name}"})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"button_icon_style" => %{"height" => height, "width" => width}},
        socket
      ) do
    class = Icon.edit_icon_size(socket.assigns.element["icon_class"], [width, height])

    updated =
      socket.assigns.element
      |> Map.merge(%{"icon_class" => class})
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
           TailwindSetting.default_element("button")
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("delete", _params, socket) do
    send(self(), {"delete", %{"delete_element" => socket.assigns.selected_form}})

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
end
