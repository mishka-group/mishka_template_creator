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
      data-type="bottom_navigation"
      id={"bottom-navigation-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      dir={@element["direction"] || "LTR"}
      reset-banner={
        JS.toggle(to: "#bottom-navigation-box-#{@id}")
        |> JS.toggle(to: "#bottom-navigation-show-#{@id}")
        |> JS.toggle(to: "#bottom-navigation-hide-#{@id}")
        |> JS.push("get_element_layout_id", value: %{myself: @myself.cid})
      }
    >
      <div class={@element["class"]} id={"bottom-navigation-box-#{@id}"}>
        <div class="grid h-full max-w-lg grid-cols-4 mx-auto font-medium">
          <%= for {%{id: _key, data: data}, _index} <- Enum.with_index(MishkaCoreComponent.sorted_list_by_order(@element["order"], @element["children"])) do %>
            <button type="button" class={@element["button_class"]}>
              <Icon.dynamic module={data["icon"]} class={@element["icon_class"]} />
              <span class={@element["title_class"]}>
                <%= data["title"] %>
              </span>
            </button>
          <% end %>
        </div>
      </div>

      <div
        class={Enum.reject(@element["class"], &(&1 in ["fixed", "bottom-0", "left-0", "z-50"]))}
        id={"bottom-navigation-section-#{@id}"}
      >
        <div class="grid h-full max-w-lg grid-cols-4 mx-auto font-medium">
          <%= for {%{id: _key, data: data}, _index} <- Enum.with_index(MishkaCoreComponent.sorted_list_by_order(@element["order"], @element["children"])) do %>
            <button type="button" class={@element["button_class"]}>
              <Icon.dynamic module={data["icon"]} class={@element["icon_class"]} />
              <span class={@element["title_class"]}>
                <%= data["title"] %>
              </span>
            </button>
          <% end %>
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

        <div class="flex flex-row justify-center items-center w-full">
          <button
            id={"bottom-navigation-hide-#{String.replace(@id, "form", "call")}"}
            phx-click={
              JS.exec("reset-banner", to: "#bottom-navigation-#{String.replace(@id, "form", "call")}")
            }
            type="button"
            class="py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200"
          >
            Hide Navigation
          </button>
          <button
            id={"bottom-navigation-show-#{String.replace(@id, "form", "call")}"}
            phx-click={
              JS.exec("reset-banner", to: "#bottom-navigation-#{String.replace(@id, "form", "call")}")
            }
            type="button"
            class="hidden py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200"
          >
            Show Navigation
          </button>
        </div>

        <Aside.aside_accordion
          id={"bottom_navigation-#{@id}"}
          title="Bottom Navigation Settings"
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
              There is no menu item for this Bottom Navigation
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
                  phx-click={JS.toggle(to: "#bottom-navigation-#{key}-#{index}")}
                >
                  <%= data["title"] %>
                </span>

                <div class="flex flex-row justify-end items-center gap-2">
                  <div
                    class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                    phx-click={JS.toggle(to: "#bottom-navigation-#{key}-#{index}")}
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

              <div id={"bottom-navigation-#{key}-#{index}"} class="hidden">
                <MishkaCoreComponent.custom_simple_form
                  :let={f}
                  for={%{}}
                  as={:bottom_navigation_component}
                  phx-submit="edit"
                  phx-target={@myself}
                  class="flex flex-col w-full justify-start gap-2 py-5"
                >

                  <p class="font-bold text-sm">Title</p>
                  <%= text_input(f, :title,
                    class:
                      "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                    placeholder: "Change Title",
                    value: data["title"],
                    id: "title-#{key}-#{index}-field"
                  ) %>

                  <p class="font-bold text-sm">Link</p>
                  <%= text_input(f, :link,
                    class:
                      "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                    placeholder: "Change Title",
                    value: data["link"],
                    id: "link-#{key}-#{index}-field"
                  ) %>

                  <p class="font-bold text-sm">Icon</p>
                  <Icon.select
                    selected={String.replace(data["icon"], "Heroicons.", "")}
                    myself={@myself}
                    block_id={key}
                  />

                  <.input
                    field={f[:key]}
                    type="hidden"
                    value={key}
                    id={"navigation-#{key}-#{index}-id"}
                  />

                  <button
                    type="submit"
                    class="w-24 px-4 py-2 mx-auto text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700"
                    phx-click={JS.toggle(to: "#bottom-navigation-#{key}-#{index}")}
                  >
                    Save
                  </button>
                </MishkaCoreComponent.custom_simple_form>
              </div>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"bottom_navigation-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion
            id={"bottom_navigation-#{@id}"}
            title="Font and Bottom Navigation Style"
            open={false}
          >
            <Text.direction_selector myself={@myself} />

            <Text.font_style
              myself={@myself}
              classes={@element["title_class"]}
              as={:public_bottom_navigation_font_style}
              id={@id}
            />

            <Color.select
              myself={@myself}
              event_name="public_bottom_navigation_font_style"
              classes={@element["title_class"]}
            />

            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              event_name="bottom_navigation_background_style"
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

  def handle_event(
        "font_style",
        %{"public_bottom_navigation_font_style" => %{"font" => font, "font_size" => font_size}},
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

  def handle_event("public_bottom_navigation_font_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["title_class"], &(&1 in text_colors)) ++ [color]

    icon_class =
      Enum.reject(socket.assigns.element["icon_class"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"title_class" => class, "icon_class" => icon_class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("bottom_navigation_background_style", %{"color" => color}, socket) do
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
