defmodule MishkaTemplateCreator.Components.Elements.Alert do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  use Phoenix.Component

  alias MishkaTemplateCreator.Components.Layout.Aside
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias MishkaTemplateCreator.Components.Blocks.Tag
  alias MishkaTemplateCreator.Components.Blocks.Color
  alias MishkaTemplateCreator.Components.Elements.Text

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
      data-type="alert"
      id={"alert-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      dir={@element["direction"] || "LTR"}
    >
      <div class={@element["class"]} role="alert">
        <span
          :if={@element["title"] != "" and !is_nil(@element["title"])}
          class={@element["title_class"]}
        >
          <%= @element["title"] %>
        </span>
        <div class={@element["content_class"]}><%= @element["html"] %></div>
      </div>
    </div>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"alert-#{@id}"}>
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
          id={"alert-#{@id}"}
          title="Button Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <MishkaCoreComponent.custom_simple_form
            :let={f}
            for={%{}}
            as={:alert_edit}
            phx-change="text_edit"
            phx-target={@myself}
            class="w-full m-0 p-0 flex flex-col"
          >
            <div class="flex flex-col w-full items-center justify-center pb-5 gap-4">
              <%= text_input(f, :title,
                class:
                  "block w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                value: @element["title"],
                placeholder: "Alert Title"
              ) %>

              <div class="block w-full">
                <%= textarea(f, :html,
                  class:
                    "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                  rows: "4",
                  value: @element["html"]
                ) %>

                <span class="w-full text-start text-xs mt-2 cursor-pointer">
                  <a
                    href="https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax"
                    target="_blank"
                    class="text-blue-400"
                  >
                    Styling with Markdown is supported, click here
                  </a>
                </span>
              </div>
            </div>
          </MishkaCoreComponent.custom_simple_form>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"alert-#{@id}"}
          title="Common Styles"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <div class="grid grid-cols-3 gap-2 w-full my-5 pt-2 items-center">
            <div
              :for={{key, classes} <- @common_style}
              class={classes}
              role="alert"
              phx-click="common_style"
              phx-value-type={key}
              phx-target={@myself}
            >
              <span
                :if={@element["title"] != "" and !is_nil(@element["title"])}
                class={@element["title_class"]}
              >
                The Title
              </span>
              <div class={@element["content_class"]}>Some Text here</div>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"alert-#{@id}"}
          title="Title and Content custom Style"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"alert-#{@id}"} title="Title style" open={false}>
            <Text.font_style
              myself={@myself}
              classes={@element["title_class"]}
              as={:title_alert_font_style}
              id={@id}
            />
            <Color.select
              myself={@myself}
              event_name="title_alert_font_style"
              classes={@element["title_class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"alert-#{@id}"} title="Content style" open={false}>
            <Text.font_style
              myself={@myself}
              classes={@element["content_class"]}
              as={:content_alert_font_style}
              id={@id}
            />
            <Color.select
              myself={@myself}
              event_name="content_alert_font_style"
              classes={@element["content_class"]}
            />
          </Aside.aside_accordion>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"alert-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"alert-#{@id}"} title="Alignment" open={false}>
            <Text.alignment_selector myself={@myself} />
            <Text.direction_selector myself={@myself} />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"alert-#{@id}"} title="Font and Alert Style" open={false}>
            <Text.font_style
              myself={@myself}
              classes={@element["class"]}
              as={:public_alert_font_style}
              id={@id}
            />

            <div class="flex flex-col w-full items-center justify-center">
              <ul class="flex flex-row mx-auto text-md border-gray-400 py-5 text-gray-600">
                <li
                  class={"#{create_border_radius(@element["class"], "rounded-none")} px-3 py-1 border border-gray-300 rounded-l-md border-r-0 hover:bg-gray-200 cursor-pointer"}
                  phx-click="border_radius"
                  phx-value-type="rounded-none"
                  phx-target={@myself}
                >
                  None
                </li>
                <li
                  class={"#{create_border_radius(@element["class"], "rounded-sm")} px-3 py-1 border border-gray-300 hover:bg-gray-200 cursor-pointer"}
                  phx-click="border_radius"
                  phx-value-type="rounded-sm"
                  phx-target={@myself}
                >
                  SM
                </li>
                <li
                  class={"#{create_border_radius(@element["class"], "rounded-md")} px-3 py-1 border border-gray-300 border-l-0 hover:bg-gray-200 cursor-pointer"}
                  phx-click="border_radius"
                  phx-value-type="rounded-md"
                  phx-target={@myself}
                >
                  MD
                </li>
                <li
                  class={"#{create_border_radius(@element["class"], "rounded-lg")} px-3 py-1 border border-gray-300 rounded-r-md border-l-0 hover:bg-gray-200 cursor-pointer"}
                  phx-click="border_radius"
                  phx-value-type="rounded-lg"
                  phx-target={@myself}
                >
                  LG
                </li>
              </ul>
            </div>

            <Color.select
              myself={@myself}
              event_name="public_alert_font_style"
              classes={@element["class"]}
            />

            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              event_name="alert_font_style"
              classes={@element["class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"alert-#{@id}"} title="Custom Tag name" open={false}>
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

  def handle_event("text_edit", %{"alert_edit" => %{"html" => html, "title" => title}}, socket) do
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
        %{"public_alert_font_style" => %{"font" => font, "font_size" => font_size}},
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
        %{"title_alert_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class = Text.edit_font_style_class(socket.assigns.element["title_class"], font_size, font)

    updated =
      socket.assigns.element
      |> Map.merge(%{"title_class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"content_alert_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class = Text.edit_font_style_class(socket.assigns.element["content_class"], font_size, font)

    updated =
      socket.assigns.element
      |> Map.merge(%{"content_class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("public_alert_font_style", %{"color" => color}, socket) do
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

  def handle_event("alert_font_style", %{"color" => color}, socket) do
    bg_colors =
      TailwindSetting.get_form_options("backgrounds", "background-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["class"], &(&1 in bg_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("content_alert_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["content_class"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"content_class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("title_alert_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["title_class"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"title_class" => class})
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

  def handle_event("border_radius", %{"type" => type}, socket) do
    borders = TailwindSetting.get_form_options("borders", "border-radius", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["class"], &(&1 in borders)) ++ [type]

    updated =
      socket.assigns.element
      |> Map.merge(%{"class" => class})
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
           TailwindSetting.default_element("alert")
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("delete", _params, socket) do
    send(self(), {"delete", %{"delete_element" => socket.assigns.selected_form}})

    {:noreply, socket}
  end

  defp create_border_radius(classes, type, bg_color \\ "") do
    Enum.find(classes, &(&1 == type))
    |> case do
      nil -> bg_color
      _ -> "bg-gray-300"
    end
  end
end
