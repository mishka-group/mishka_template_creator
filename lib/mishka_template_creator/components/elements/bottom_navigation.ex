defmodule MishkaTemplateCreator.Components.Elements.BottomNavigation do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias MishkaTemplateCreator.Components.Layout.Aside
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias MishkaTemplateCreator.Components.Blocks.Tag
  alias MishkaTemplateCreator.Components.Blocks.Color
  alias MishkaTemplateCreator.Components.Elements.Text
  alias MishkaTemplateCreator.Components.Blocks.Icon

  @common_style %{
    "info" => [
      "flex",
      "flex-col",
      "gap-2",
      "px-4",
      "py-2",
      "text-blue-800",
      "border",
      "border-blue-300",
      "rounded-lg",
      "bg-blue-50",
      "text-xs"
    ],
    "danger" => [
      "flex",
      "flex-col",
      "gap-2",
      "px-4",
      "py-2",
      "text-red-800",
      "border",
      "border-red-300",
      "rounded-lg",
      "bg-red-50",
      "text-xs"
    ],
    "success" => [
      "flex",
      "flex-col",
      "gap-2",
      "px-4",
      "py-2",
      "text-green-800",
      "border",
      "border-green-300",
      "rounded-lg",
      "bg-green-50",
      "text-xs"
    ],
    "warning" => [
      "flex",
      "flex-col",
      "gap-2",
      "px-4",
      "py-2",
      "text-yellow-800",
      "border",
      "border-yellow-300",
      "rounded-lg",
      "bg-yellow-50",
      "text-xs"
    ],
    "light" => [
      "flex",
      "flex-col",
      "gap-2",
      "px-4",
      "py-2",
      "text-gray-800",
      "border",
      "border-gray-300",
      "rounded-lg",
      "bg-gray-50",
      "text-xs"
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
      data-type="bottom_navigation"
      id={"bottom_navigation-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      dir={@element["direction"] || "LTR"}
    >
      <div class="fixed bottom-0 left-0 z-50 w-full h-16 bg-white border-t border-gray-200">
        <div class="grid h-full max-w-lg grid-cols-4 mx-auto font-medium">
          <button
            type="button"
            class="inline-flex flex-col items-center justify-center px-5 hover:bg-gray-50 group/item"
          >
            <Heroicons.home class="w-6 h-6 mb-1 text-gray-500 group-hover/item:text-red-600" />
            <span class="text-sm text-gray-500 group-hover/item:text-red-600">
              Home
            </span>
          </button>
          <button
            type="button"
            class="inline-flex flex-col items-center justify-center px-5 hover:bg-gray-50 group/item"
          >
            <Heroicons.wallet class="w-6 h-6 mb-1 text-gray-500 group-hover/item:text-blue-600" />
            <span class="text-sm text-gray-500 group-hover/item:text-blue-600">
              Wallet
            </span>
          </button>
          <button
            type="button"
            class="inline-flex flex-col items-center justify-center px-5 hover:bg-gray-50 group/item"
          >
            <Heroicons.server class="w-6 h-6 mb-1 text-gray-500 group-hover/item:text-blue-600" />
            <span class="text-sm text-gray-500 group-hover/item:text-blue-600">
              Settings
            </span>
          </button>
          <button
            type="button"
            class="inline-flex flex-col items-center justify-center px-5 hover:bg-gray-50 group/item"
          >
            <Heroicons.user class="w-6 h-6 mb-1 text-gray-500 group-hover/item:text-blue-600" />
            <span class="text-sm text-gray-500 group-hover/item:text-blue-600">
              Profile
            </span>
          </button>
        </div>
      </div>
    </div>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"bottom_navigation-#{@id}"}>
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
          id={"bottom_navigation-#{@id}"}
          title="Bottom Navigation Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          sss
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"bottom_navigation-#{@id}"}
          title="Common Styles"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <div class="grid grid-cols-3 gap-2 w-full my-5 pt-2 items-center">
            <div
              :for={{key, classes} <- @common_style}
              class={classes}
              role="bottom_navigation"
              phx-click="common_style"
              phx-value-type={key}
              phx-target={@myself}
            >
              <span
                :if={@element["title"] != "" and !is_nil(@element["title"])}
                class="font-medium text-sm"
              >
                The Title
              </span>
              <div class={@element["content_class"]}>Some Text here</div>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"bottom_navigation-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"bottom_navigation-#{@id}"} title="Alignment" open={false}>
            <Text.alignment_selector myself={@myself} />
            <Text.direction_selector myself={@myself} />
          </Aside.aside_accordion>

          <Aside.aside_accordion
            id={"bottom_navigation-#{@id}"}
            title="Font and bottom_navigation Style"
            open={false}
          >
            <Text.font_style
              myself={@myself}
              classes={@element["class"]}
              as={:public_bottom_navigation_font_style}
              id={@id}
            />

            <Color.select
              myself={@myself}
              event_name="public_bottom_navigation_font_style"
              classes={@element["class"]}
            />

            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              event_name="bottom_navigation_font_style"
              classes={@element["class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"bottom_navigation-#{@id}"} title="Custom Tag name" open={false}>
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

  def handle_event(
        "text_edit",
        %{"bottom_navigation_edit" => %{"html" => html, "title" => title}},
        socket
      ) do
    updated =
      socket.assigns.element
      |> Map.merge(%{"html" => html, "title" => title})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

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
        %{"public_bottom_navigation_font_style" => %{"font" => font, "font_size" => font_size}},
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

  def handle_event("public_bottom_navigation_font_style", %{"color" => color}, socket) do
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

  def handle_event("common_style", %{"type" => type}, socket) do
    updated =
      socket.assigns.element
      |> Map.merge(%{"class" => @common_style[type]})
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
           TailwindSetting.default_element("bottom_navigation")
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("delete", _params, socket) do
    send(self(), {"delete", %{"delete_element" => socket.assigns.selected_form}})

    {:noreply, socket}
  end
end
