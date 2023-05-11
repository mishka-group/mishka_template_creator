defmodule MishkaTemplateCreator.Components.Elements.Banner do
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
    "sticky_top" => [
      "fixed",
      "top-0",
      "left-0",
      "z-50",
      "flex",
      "justify-between",
      "w-full",
      "p-4",
      "border",
      "border-gray-200",
      "bg-gray-50",
      "text-base"
    ],
    "sticky_bottom" => [
      "fixed",
      "bottom-0",
      "left-0",
      "z-50",
      "flex",
      "justify-between",
      "w-full",
      "p-4",
      "border",
      "border-gray-200",
      "bg-gray-50",
      "text-base"
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
      data-type="banner"
      id={"banner-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      dir={@element["direction"] || "LTR"}
      reset-banner={
        JS.toggle(to: "#banner-box-#{@id}")
        |> JS.toggle(to: "#banner-show-#{@id}")
        |> JS.toggle(to: "#banner-hide-#{@id}")
        |> JS.push("get_element_layout_id", value: %{myself: @myself.cid})
      }
    >
      <div id={"banner-box-#{@id}"} tabindex="-1">
        <div class={@element["class"]}>
          <div class="flex items-center mx-auto">
            <p class="flex items-center text-sm font-normal text-gray-500">
              <span class="inline-flex p-1 mx-3 bg-gray-200 rounded-full">
                <Icon.dynamic module={@element["icon"]} class={@element["icon_class"]} />
                <span class="sr-only">Light bulb</span>
              </span>
              <%= Phoenix.HTML.raw(@element["html"]) %>
            </p>
          </div>
          <div class="flex items-center">
            <button
              phx-click={JS.exec("reset-banner", to: "#banner-#{@id}")}
              type="button"
              class={@element["close_btn"]}
            >
              <Icon.dynamic module={@element["close_icon"]} class={@element["close_icon_class"]} />
              <span class="sr-only">Close banner</span>
            </button>
          </div>
        </div>
      </div>

      <div class="flex justify-between w-full p-4 border border-gray-200 bg-gray-50 text-base">
        <div class="flex items-center mx-auto">
          <p class="flex items-center text-sm font-normal text-gray-500">
            <span class="inline-flex p-1 mx-3 bg-gray-200 rounded-full">
              <Icon.dynamic module={@element["icon"]} class={@element["icon_class"]} />
              <span class="sr-only">Light bulb</span>
            </span>
            <%= Phoenix.HTML.raw(@element["html"]) %>
          </p>
        </div>
        <div class="flex items-center">
          <button
            phx-click={JS.exec("reset-banner", to: "#banner-#{@id}")}
            type="button"
            class={@element["close_btn"]}
          >
            <Icon.dynamic module={@element["close_icon"]} class={@element["close_icon_class"]} />
            <span class="sr-only">Close banner</span>
          </button>
        </div>
      </div>
    </div>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"banner-#{@id}"}>
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

        <div class="flex flex-row justify-center items-center w-full">
          <button
            id={"banner-hide-#{@id}"}
            phx-click={JS.exec("reset-banner", to: "#banner-#{String.replace(@id, "form", "call")}")}
            type="button"
            class="py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200"
          >
            Hide Banner
          </button>
          <button
            id={"banner-show-#{@id}"}
            phx-click={JS.exec("reset-banner", to: "#banner-#{String.replace(@id, "form", "call")}")}
            type="button"
            class="hidden py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200"
          >
            Show Banner
          </button>
        </div>

        <Aside.aside_accordion
          id={"banner-#{@id}"}
          title="banner Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <MishkaCoreComponent.custom_simple_form
            :let={f}
            for={%{}}
            as={:banner_edit}
            phx-change="text_edit"
            phx-target={@myself}
            class="w-full m-0 p-0 flex flex-col"
          >
            <div class="flex flex-col w-full items-center justify-center pb-5 gap-4">
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
          id={"banner-#{@id}"}
          title="Common Styles"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <div class="flex flex-warp gap-2 w-full my-5 pt-2 items-center">
            <div
              :for={{key, classes} <- @common_style}
              role="banner"
              phx-click="common_style"
              phx-value-type={key}
              phx-target={@myself}
            >
              <span class="flex flex-row items-center px-2 py-1 text-sm font-medium text-gray-800 bg-gray-100 rounded cursor-pointer hover:bg-gray-300 hover:text-gray-900">
                <button
                  type="button"
                  class="inline-flex items-center p-0.5 text-sm bg-transparent rounded-sm hover:bg-gray-200 hover:text-gray-900"
                >
                  <Heroicons.stop class="w-5 h-5" />
                </button>
                <%= String.replace(key, "_", " ") |> String.upcase() %>
              </span>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"banner-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"banner-#{@id}"} title="Icon Settings" open={false}>
            <Icon.select
              selected={String.replace(@element["icon"], "Heroicons.", "")}
              myself={@myself}
              block_id={@id}
            />

            <Icon.select_size
              myself={@myself}
              classes={@element["icon_class"]}
              as={:banner_icon_style}
              id_input={@id}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"banner-#{@id}"} title="Font and banner Style" open={false}>
            <Text.direction_selector myself={@myself} />
            <Text.font_style
              myself={@myself}
              classes={@element["class"]}
              as={:public_banner_font_style}
              id={@id}
            />

            <Color.select
              myself={@myself}
              event_name="public_banner_font_style"
              classes={@element["class"]}
            />

            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              event_name="banner_background_style"
              classes={@element["class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"banner-#{@id}"} title="Custom Tag name" open={false}>
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

  def handle_event("text_edit", %{"banner_edit" => %{"html" => html}}, socket) do
    updated =
      socket.assigns.element
      |> Map.merge(%{"html" => html})
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

  def handle_event(
        "font_style",
        %{"public_banner_font_style" => %{"font" => font, "font_size" => font_size}},
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

  def handle_event("public_banner_font_style", %{"color" => color}, socket) do
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

  def handle_event("banner_background_style", %{"color" => color}, socket) do
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

  def handle_event("common_style", %{"type" => type}, socket) do
    updated =
      socket.assigns.element
      |> Map.merge(%{"class" => @common_style[type]})
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
        %{"banner_icon_style" => %{"height" => height, "width" => width}},
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
           TailwindSetting.default_element("banner")
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
