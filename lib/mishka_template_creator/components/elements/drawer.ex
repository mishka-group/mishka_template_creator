defmodule MishkaTemplateCreator.Components.Elements.Drawer do
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
      data-type="drawer"
      id={"drawer-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      dir={@element["direction"] || "LTR"}
      data-close-menu={
        JS.remove_class("transform-none", to: "#drawer-#{@id}-navigation")
        |> JS.add_class("ltr:-translate-x-full rtl:translate-x-full", to: "#drawer-#{@id}-navigation")
      }
      data-open-menu={
        JS.add_class("transform-none", to: "#drawer-#{@id}-navigation")
        |> JS.remove_class("ltr:-translate-x-full rtl:translate-x-full",
          to: "#drawer-#{@id}-navigation"
        )
      }
    >
      <button
        phx-click={JS.exec("data-open-menu", to: "#drawer-#{@id}")}
        type="button"
        class={@element["sidebar_button_class"]}
      >
        <Icon.dynamic
          module={@element["sidebar_button_icon"]}
          class={@element["sidebar_button_icon_class"]}
        />
      </button>
      <div id={"drawer-#{@id}-navigation"} class={@element["class"]} tabindex="-1">
        <h5 id="drawer-navigation-label" class={@element["title_class"]}>
          <%= @element["title"] %>
        </h5>
        <button
          type="button"
          class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 absolute top-2.5 ltr:right-2.5 inline-flex items-center rtl:left-2.5"
          phx-click={JS.exec("data-close-menu", to: "#drawer-#{@id}")}
        >
          <Heroicons.x_mark class="w-5 h-5" />
          <span class="sr-only">Close menu</span>
        </button>

        <div class="py-4 overflow-y-auto">
          <ul class="space-y-2">
            <li :for={
              {%{id: _key, data: data}, _index} <-
                Enum.with_index(
                  MishkaCoreComponent.sorted_list_by_order(@element["order"], @element["children"])
                )
            }>
              <a href="#" class={@element["link_class"]}>
                <Icon.dynamic module={data["icon"]} class={@element["icon_class"]} />
                <span class="ml-3"><%= data["title"] %></span>
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"drawer-#{@id}"}>
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
            phx-click={
              JS.exec("data-close-menu", to: "#drawer-#{String.replace(@id, "form", "call")}")
            }
            type="button"
            class="py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200"
          >
            Hide Drawer
          </button>
          <button
            phx-click={
              JS.exec("data-open-menu", to: "#drawer-#{String.replace(@id, "form", "call")}")
            }
            type="button"
            class="py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200"
          >
            Show Drawer
          </button>
        </div>

        <div class="flex flex-row justify-center items-center w-full">
          <button
            phx-click={JS.push("position", value: %{side: "left"})}
            phx-target={@myself}
            type="button"
            class="py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200"
          >
            <Heroicons.bars_3_center_left class="w-5 h-5" />
          </button>
          <button
            phx-click={JS.push("position", value: %{side: "right"})}
            phx-target={@myself}
            type="button"
            class="py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200"
          >
            <Heroicons.bars_3_bottom_right class="w-5 h-5" />
          </button>
        </div>

        <Aside.aside_accordion
          id={"drawer-#{@id}"}
          title="Drawer Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <:before_title_block>
            <Heroicons.plus class="w-5 h-5 cursor-pointer" phx-click="add" phx-target={@myself} />
          </:before_title_block>

          <div class="w-full flex flex-col gap-3 space-y-4 pt-3">
            <span
              :if={length(@element["order"]) == 0}
              class="mx-auto border border-gray-200 bg-gray-100 font-bold py-2 px-3"
            >
              There is no menu item for this Drawer
            </span>

            <div
              :for={
                {%{id: key, data: data}, index} <-
                  Enum.with_index(
                    MishkaCoreComponent.sorted_list_by_order(@element["order"], @element["children"])
                  )
              }
              class="w-full flex flex-col justify-between items-center"
            >
              <div class="w-full flex flex-row justify-between items-center">
                <span
                  class="font-bold text-base select-none cursor-pointer"
                  id={"title-#{key}-#{index}"}
                  phx-click={JS.toggle(to: "#drawer-#{key}-#{index}")}
                >
                  <%= data["title"] %>
                </span>

                <div class="flex flex-row justify-end items-center gap-2">
                  <div
                    class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                    phx-click={JS.toggle(to: "#drawer-#{key}-#{index}")}
                  >
                    <Heroicons.pencil_square class="w-5 h-5" />
                    <span class="text-base select-none">
                      Edit
                    </span>
                  </div>
                  <div
                    class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                    phx-click="delete"
                    phx-value-id={key}
                    phx-target={@myself}
                  >
                    <Heroicons.trash class="w-5 h-5 text-red-600" />
                    <span class="text-base select-none">Delete</span>
                  </div>
                </div>
              </div>

              <div id={"drawer-#{key}-#{index}"} class="hidden w-full">
                <MishkaCoreComponent.custom_simple_form
                  :let={f}
                  for={%{}}
                  as={:drawer_component}
                  phx-change="edit"
                  phx-target={@myself}
                  class="flex flex-col w-full justify-start gap-3 py-5"
                >
                  <div class="flex flex-row justify-between items-center w-full gap-5">
                    <div class="flex flex-col gap-2 w-full">
                      <p class="font-bold text-sm">Title</p>
                      <%= text_input(f, :title,
                        class:
                          "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                        placeholder: "Change Title",
                        value: data["title"],
                        id: "title-#{key}-#{index}-field"
                      ) %>
                    </div>

                    <div class="flex flex-col gap-2 w-full">
                      <p class="font-bold text-sm">Link</p>
                      <%= text_input(f, :link,
                        class:
                          "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                        placeholder: "Change Link",
                        value: data["link"],
                        id: "image-#{key}-#{index}-field"
                      ) %>
                    </div>
                  </div>

                  <p class="w-full font-bold text-sm mt-5">
                    Select Icon:
                  </p>
                  <div class="px-5 pb-3 mt-3">
                    <Icon.select
                      selected={String.replace(data["icon"], "Heroicons.", "")}
                      myself={@myself}
                      block_id={key}
                    />
                  </div>

                  <.input
                    field={f[:key]}
                    type="hidden"
                    value={key}
                    id={"navigation-#{key}-#{index}-id"}
                  />
                </MishkaCoreComponent.custom_simple_form>
              </div>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"drawer-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion
            id={"drawer-#{@id}"}
            title="Drawer Navigation Button Style "
            open={false}
          >
            <div class="flex flex-col w-full items-center justify-center pb-5">
              <MishkaCoreComponent.custom_simple_form
                :let={f}
                for={%{}}
                as={:drawer_component}
                phx-change="edit"
                phx-target={@myself}
                class="flex flex-col w-full justify-start gap-3 py-5"
              >
                <div class="flex flex-col justify-between items-start w-full gap-3">
                  <p class="font-bold text-sm">Title</p>
                  <%= text_input(f, :title,
                    class:
                      "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                    placeholder: "Change Title",
                    value: @element["title"],
                    id: "title-#{@id}-field"
                  ) %>
                </div>
              </MishkaCoreComponent.custom_simple_form>

              <Text.font_style
                myself={@myself}
                classes={@element["title_class"]}
                as={:drawer_title_font_style}
                id={@id}
              />

              <Color.select
                title="Title Color:"
                myself={@myself}
                event_name="drawer_title_font_style"
                classes={@element["title_class"]}
              />

              <p class="w-full font-bold text-sm mt-5 mb-4">
                Select Navigation button Icon:
              </p>
              <div class="px-5 pb-3">
                <Icon.select
                  selected={String.replace(@element["sidebar_button_icon"], "Heroicons.", "")}
                  myself={@myself}
                  block_id={@id}
                  event_name="select_button_icon"
                />
              </div>

              <Icon.select_size
                myself={@myself}
                classes={@element["sidebar_button_icon_class"]}
                as={:drawer_icon_style}
                id_input={@id}
              />

              <Color.select
                myself={@myself}
                event_name="drawer_icon_font_style"
                classes={@element["sidebar_button_icon_class"]}
              />

              <Color.select
                title="Navigation button Border Color:"
                type="border"
                myself={@myself}
                event_name="drawer_border_style"
                classes={@element["sidebar_button_class"]}
              />
            </div>
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"drawer-#{@id}"} title="Direction and Menus Style" open={false}>
            <Text.direction_selector myself={@myself} />

            <Text.font_style
              myself={@myself}
              classes={@element["link_class"]}
              as={:drawer_menu_font_style}
              id={@id}
            />

            <Icon.select_size
              myself={@myself}
              classes={@element["icon_class"]}
              as={:drawer_menu_icon_style}
              id_input={@id}
              id={@id}
            />

            <Color.select
              title="Link Color:"
              myself={@myself}
              event_name="drawer_menu_link_style"
              classes={@element["link_class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"drawer-#{@id}"} title="Custom Tag name" open={false}>
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

  def handle_event("add", _params, socket) do
    unique_id = Ecto.UUID.generate()

    updated =
      socket.assigns.element
      |> update_in(["children"], fn selected_element ->
        Map.merge(selected_element, %{
          "#{unique_id}" => %{
            "title" => "Test Menu",
            "icon" => "Heroicons.square_2_stack",
            "link" => "#"
          }
        })
      end)
      |> Map.merge(%{"order" => socket.assigns.element["order"] ++ [unique_id]})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "edit",
        %{
          "drawer_component" => %{"title" => title, "link" => link, "key" => id}
        },
        socket
      ) do
    updated =
      socket.assigns.element
      |> update_in(["children", id], fn selected_element ->
        Map.merge(selected_element, %{"title" => title, "link" => link})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("edit", %{"drawer_component" => %{"title" => title}}, socket) do
    updated =
      socket.assigns.element
      |> Map.merge(%{"title" => title})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"drawer_icon_style" => %{"height" => height, "width" => width}},
        socket
      ) do
    class =
      Icon.edit_icon_size(socket.assigns.element["sidebar_button_icon_class"], [width, height])

    updated =
      socket.assigns.element
      |> Map.merge(%{"sidebar_button_icon_class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("drawer_icon_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["sidebar_button_icon_class"], &(&1 in text_colors)) ++
        [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"sidebar_button_icon_class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("drawer_title_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["title_class"], &(&1 in text_colors)) ++
        [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"title_class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("drawer_border_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("borders", "border-color", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["sidebar_button_class"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"sidebar_button_class" => class})
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

  def handle_event("select_button_icon", %{"name" => name, "block-id" => _id}, socket) do
    updated =
      socket.assigns.element
      |> Map.merge(%{"sidebar_button_icon" => "Heroicons.#{name}"})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

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
        %{"drawer_title_font_style" => %{"font" => font, "font_size" => font_size}},
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
        %{"drawer_menu_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class = Text.edit_font_style_class(socket.assigns.element["link_class"], font_size, font)

    updated =
      socket.assigns.element
      |> Map.merge(%{"link_class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("drawer_menu_link_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["link_class"], &(&1 in text_colors)) ++ [color]

    icon_class =
      Enum.reject(socket.assigns.element["icon_class"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"link_class" => class, "icon_class" => icon_class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"drawer_menu_icon_style" => %{"height" => height, "width" => width}},
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

  def handle_event("position", %{"side" => side}, socket) do
    class =
      case side do
        "left" ->
          Enum.reject(socket.assigns.element["class"], &(&1 == "right-0")) ++ ["left-0"]

        _ ->
          Enum.reject(socket.assigns.element["class"], &(&1 == "left-0")) ++ ["right-0"]
      end

    updated =
      socket.assigns.element
      |> Map.merge(%{"class" => class, "direction" => if(side == "left", do: "LTR", else: "RTL")})
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
           TailwindSetting.default_element("drawer")
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
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
end
