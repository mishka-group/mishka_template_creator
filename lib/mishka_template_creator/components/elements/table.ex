defmodule MishkaTemplateCreator.Components.Elements.Table do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form
  use Phoenix.Component

  alias MishkaTemplateCreator.Components.Blocks.Aside
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias Phoenix.LiveView.JS

  %{
    "unique_id" => %{
      "children" => %{
        "unique_id-0" => %{"title" => "", "html" => "", "icon" => ""},
        "unique_id-1" => %{"title" => "", "html" => "", "icon" => ""}
      },
      "header" => %{
        "row" => "",
        "column" => ""
      },
      "content" => %{
        "row" => "",
        "column" => ""
      },
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

    {:ok,
     assign(socket,
       id: id,
       render_type: render_type,
       selected_form: selected_form,
       element: element,
       submit: submit
     )}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(%{render_type: "call"} = assigns) do
    ~H"""
    <div
      data-type="table"
      id={"table-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      class={@element["class"]}
      dir={@element["direction"] || "LTR"}
    >
      <div class="relative overflow-x-auto">
        <table class="w-full">
          <thead class={@element["header"]["row"]}>
            <tr>
              <th
                :for={title <- @element["children"]["headers"]}
                scope="col"
                class={@element["header"]["column"]}
              >
                <%= title %>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr
              :for={
                %{id: _key, data: data} <-
                  MishkaCoreComponent.sorted_list_by_order(
                    @element["order"],
                    @element["children"]["content"]
                  )
              }
              class={@element["content"]["row"]}
            >
              <td :for={item <- data} class={@element["content"]["column"]}>
                <%= item %>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  @impl true
  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"table-#{@id}"}>
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
          id={"table-#{@id}"}
          title="Table Headers Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <:before_title_block>
            <Heroicons.plus
              class="w-5 h-5 cursor-pointer"
              phx-click="add"
              phx-value-type="header"
              phx-target={@myself}
            />
          </:before_title_block>

          <div class="w-full flex flex-col gap-3 space-y-4 pt-3">
            <div
              :for={{title, index} <- Enum.with_index(@element["children"]["headers"])}
              class="w-full flex flex-row justify-between items-center"
            >
              <span class="font-bold text-base"><%= title %></span>
              <div class="flex flex-row justify-end items-center gap-2">
                <div class="flex flex-row justify-center items-start gap-2 cursor-pointer">
                  <Heroicons.pencil_square class="w-5 h-5" />
                  <span class="text-base select-none">Edit</span>
                </div>
                <div
                  class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                  phx-click="delete"
                  phx-value-type="header"
                  phx-value-index={index}
                  phx-target={@myself}
                >
                  <Heroicons.trash class="w-5 h-5 text-red-600" />
                  <span class="text-base select-none">Delete</span>
                </div>
              </div>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"table-#{@id}"}
          title="Table Rows Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <:before_title_block>
            <Heroicons.plus
              class="w-5 h-5 cursor-pointer"
              phx-click="add"
              phx-value-type="content"
              phx-target={@myself}
            />
          </:before_title_block>

          <div class="flex flex-col w-full gap-3 space-y-4 pt-3">
            <div
              :for={
                {%{id: key, data: data}, index} <-
                  Enum.with_index(
                    MishkaCoreComponent.sorted_list_by_order(
                      @element["order"],
                      @element["children"]["content"]
                    ),
                    1
                  )
              }
              class="w-full flex flex-col justify-between items-center"
            >
              <div class="w-full flex flex-row justify-between items-center pb-3">
                <span
                  class="text-base select-none cursor-pointer"
                  phx-click={JS.toggle(to: "#table-content-#{@id}-#{key}")}
                >
                  Row-<%= index %>:
                </span>
                <div class="flex flex-row justify-end items-center gap-2">
                  <div
                    class="flex flex-row justify-center items-start gap-1 cursor-pointer"
                    phx-click="add_item"
                    phx-value-type="content"
                    phx-value-id={key}
                    phx-value-index={index}
                    phx-target={@myself}
                  >
                    <Heroicons.plus class="w-5 h-5" />
                    <span class="text-base select-none">Add</span>
                  </div>
                  <div
                    class="flex flex-row justify-center items-start gap-1 cursor-pointer"
                    phx-click="delete"
                    phx-value-type="content"
                    phx-value-id={key}
                    phx-value-index={index}
                    phx-target={@myself}
                  >
                    <Heroicons.trash class="w-5 h-5 text-red-600" />
                    <span class="text-base select-none">Delete</span>
                  </div>
                </div>
              </div>
              <div id={"table-content-#{@id}-#{key}"} class={"w-full #{if index != 1, do: "hidden"}"}>
                <div class="w-full flex flex-wrap p-3 gap-2">
                  <span
                    :for={{item, index} <- Enum.with_index(data)}
                    class="group text-sm border border-gray-200 rounded-md py-2 px-3 bg-gray-100 relative"
                  >
                    <%= item %>
                    <span class="hidden group-hover:flex group-hover:absolute left-1 duration-100 group-hover:duration-150 gap-2">
                      <Heroicons.trash
                        class="w-5 h-5 text-red-600 cursor-pointer"
                        phx-click="delete_item"
                        phx-value-type="content_item"
                        phx-value-index={index}
                        phx-value-id={key}
                        phx-target={@myself}
                      />
                      <Heroicons.pencil_square
                        class="w-5 h-5 cursor-pointer"
                        phx-click="edit_item"
                        phx-value-type="content_item"
                        phx-value-index={index}
                        phx-value-id={key}
                        phx-target={@myself}
                      />
                    </span>
                  </span>
                </div>
              </div>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"table-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"table-#{@id}"} title="Alignment" open={false}>
            <div class="flex flex-col w-full items-center justify-center">
              <ul class="flex flex-row mx-auto text-md border-gray-400 py-5 text-gray-600">
                <li
                  class="px-3 py-1 border border-gray-300 rounded-l-md border-r-0 hover:bg-gray-200 cursor-pointer"
                  phx-click="text_alignment"
                  phx-value-type="start"
                  phx-target={@myself}
                >
                  <Heroicons.bars_3_center_left class="w-6 h-6" />
                </li>
                <li
                  class="px-3 py-1 border border-gray-300 hover:bg-gray-200 cursor-pointer"
                  phx-click="text_alignment"
                  phx-value-type="center"
                  phx-target={@myself}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="w-6 h-6"
                    fill="currentColor"
                    class="bi bi-text-center"
                    viewBox="0 0 16 16"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M4 12.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zm-2-3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5zm2-3a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zm-2-3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5z"
                    />
                  </svg>
                </li>
                <li
                  class="px-3 py-1 border border-gray-300 border-l-0 hover:bg-gray-200 cursor-pointer"
                  phx-click="text_alignment"
                  phx-value-type="end"
                  phx-target={@myself}
                >
                  <Heroicons.bars_3_bottom_right class="w-6 h-6" />
                </li>
                <li
                  class="px-3 py-1 border border-gray-300 rounded-r-md border-l-0 hover:bg-gray-200 cursor-pointer"
                  phx-click="text_alignment"
                  phx-value-type="justify"
                  phx-target={@myself}
                >
                  <Heroicons.bars_3 class="w-6 h-6" />
                </li>
              </ul>
            </div>

            <div class="flex flex-col mt-2 pb-1 justify-between w-full">
              <p class="w-full text-start font-bold text-lg select-none">Direction:</p>
              <ul class="flex flex-row mx-auto text-md border-gray-400 py-5 text-gray-600">
                <li
                  class="px-3 py-1 border border-gray-300 rounded-l-md hover:bg-gray-200 cursor-pointer"
                  phx-click="text_direction"
                  phx-value-type="LTR"
                  phx-target={@myself}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="currentColor"
                    class="w-6 h-6"
                    viewBox="0 0 16 16"
                  >
                    <path d="M2.5 3a.5.5 0 0 0 0 1h11a.5.5 0 0 0 0-1h-11zm5 3a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1h-6zm0 3a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1h-6zm-5 3a.5.5 0 0 0 0 1h11a.5.5 0 0 0 0-1h-11zm.79-5.373c.112-.078.26-.17.444-.275L3.524 6c-.122.074-.272.17-.452.287-.18.117-.35.26-.51.428a2.425 2.425 0 0 0-.398.562c-.11.207-.164.438-.164.692 0 .36.072.65.217.873.144.219.385.328.72.328.215 0 .383-.07.504-.211a.697.697 0 0 0 .188-.463c0-.23-.07-.404-.211-.521-.137-.121-.326-.182-.568-.182h-.282c.024-.203.065-.37.123-.498a1.38 1.38 0 0 1 .252-.37 1.94 1.94 0 0 1 .346-.298zm2.167 0c.113-.078.262-.17.445-.275L5.692 6c-.122.074-.272.17-.452.287-.18.117-.35.26-.51.428a2.425 2.425 0 0 0-.398.562c-.11.207-.164.438-.164.692 0 .36.072.65.217.873.144.219.385.328.72.328.215 0 .383-.07.504-.211a.697.697 0 0 0 .188-.463c0-.23-.07-.404-.211-.521-.137-.121-.326-.182-.568-.182h-.282a1.75 1.75 0 0 1 .118-.492c.058-.13.144-.254.257-.375a1.94 1.94 0 0 1 .346-.3z" />
                  </svg>
                </li>
                <li
                  class="px-3 py-1 border border-gray-300 rounded-r-md border-l-0 hover:bg-gray-200 cursor-pointer"
                  phx-click="text_direction"
                  phx-value-type="RTL"
                  phx-target={@myself}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="currentColor"
                    class="w-6 h-6"
                    viewBox="0 0 16 16"
                  >
                    <path d="M2.5 3a.5.5 0 0 0 0 1h11a.5.5 0 0 0 0-1h-11zm0 3a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1h-6zm0 3a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1h-6zm0 3a.5.5 0 0 0 0 1h11a.5.5 0 0 0 0-1h-11zm10.113-5.373a6.59 6.59 0 0 0-.445-.275l.21-.352c.122.074.272.17.452.287.18.117.35.26.51.428.156.164.289.351.398.562.11.207.164.438.164.692 0 .36-.072.65-.216.873-.145.219-.385.328-.721.328-.215 0-.383-.07-.504-.211a.697.697 0 0 1-.188-.463c0-.23.07-.404.211-.521.137-.121.326-.182.569-.182h.281a1.686 1.686 0 0 0-.123-.498 1.379 1.379 0 0 0-.252-.37 1.94 1.94 0 0 0-.346-.298zm-2.168 0A6.59 6.59 0 0 0 10 6.352L10.21 6c.122.074.272.17.452.287.18.117.35.26.51.428.156.164.289.351.398.562.11.207.164.438.164.692 0 .36-.072.65-.216.873-.145.219-.385.328-.721.328-.215 0-.383-.07-.504-.211a.697.697 0 0 1-.188-.463c0-.23.07-.404.211-.521.137-.121.327-.182.569-.182h.281a1.749 1.749 0 0 0-.117-.492 1.402 1.402 0 0 0-.258-.375 1.94 1.94 0 0 0-.346-.3z" />
                  </svg>
                </li>
              </ul>
            </div>
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"table-#{@id}"} title="Font Style" open={false}>
            <MishkaCoreComponent.custom_simple_form
              :let={f}
              for={%{}}
              as={:public_tab_font_style}
              phx-change="font_style"
              phx-target={@myself}
              class="w-full m-0 p-0 flex flex-col"
            >
              <div class="flex flex-row w-full justify-between items-stretch pt-3 pb-5">
                <span class="w-3/5">Font:</span>
                <div class="w-full">
                  <%= select(f, :font, ["font-sans", "font-serif", "font-mono"],
                    class:
                      "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-1",
                    prompt: "Choose preferred font",
                    selected:
                      Enum.find(
                        @element["class"],
                        &(&1 in TailwindSetting.get_form_options(
                            "typography",
                            "font-family",
                            nil,
                            nil
                          ).form_configs)
                      ),
                    id: "public_tab_font-#{@id}"
                  ) %>
                </div>
              </div>
              <div class="flex flex-row w-full justify-between items-stretch pt-3 pb-5">
                <span class="w-3/5">Size:</span>
                <div class="flex flex-row w-full gap-2 items-center">
                  <span class="py-1 px-2 border border-gray-300 text-xs rounded-md">
                    <%= TailwindSetting.find_text_size_index(@element["class"]).index %>
                  </span>
                  <%= range_input(f, :font_size,
                    min: "1",
                    max: "13",
                    value: TailwindSetting.find_text_size_index(@element["class"]).index,
                    class: "w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer",
                    id: "public_tab_font_size-#{@id}"
                  ) %>
                </div>
              </div>
            </MishkaCoreComponent.custom_simple_form>
            <MishkaCoreComponent.color_selector
              myself={@myself}
              event_name="public_tab_font_style"
              classes={@element["class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"table-#{@id}"} title="Custom Tag name" open={false}>
            <div class="flex flex-col w-full items-center justify-center pb-5">
              <MishkaCoreComponent.custom_simple_form
                :let={f}
                for={%{}}
                as={:public_tab_tag}
                phx-change="validate"
                phx-submit="element"
                phx-target={@myself}
                class="w-full m-0 p-0 flex flex-col"
              >
                <%= text_input(f, :tag,
                  class:
                    "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                  placeholder: "Change Tag name",
                  value: @element["tag"],
                  id: "public_tab_tag-#{@id}"
                ) %>
                <p class={"text-xs #{if @submit, do: "text-red-500", else: ""} my-3 text-justify"}>
                  Please use only letters and numbers in naming and also keep in mind that you can only use (<code class="text-pink-400">-</code>) between letters. It should be noted, the tag name must be more than 4 characters.
                </p>
              </MishkaCoreComponent.custom_simple_form>
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

  def handle_event("validate", %{"public_tab_tag" => %{"tag" => tag}}, socket) do
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
    class = edit_font_style_class(socket.assigns.element["class"], font_size, font)

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

  def handle_event("reset", _params, socket) do
    send(
      self(),
      {"element",
       %{
         "update_parame" =>
           TailwindSetting.default_element("table")
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("add", %{"type" => "header"}, socket) do
    updated =
      socket.assigns.element
      |> update_in(["children", "headers"], fn selected_element ->
        selected_element ++ ["New Title"]
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("delete", %{"type" => "header", "index" => index}, socket) do
    updated =
      socket.assigns.element
      |> update_in(["children", "headers"], fn selected_element ->
        List.delete_at(selected_element, String.to_integer(index))
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("delete", _params, socket) do
    send(self(), {"delete", %{"delete_element" => socket.assigns.selected_form}})

    {:noreply, socket}
  end

  def handle_event("delete_item", %{"type" => "content_item", "index" => _index}, socket) do
    {:noreply, socket}
  end

  def handle_event("edit_item", %{"type" => "content_item", "index" => _index}, socket) do
    {:noreply, socket}
  end

  defp edit_font_style_class(classes, font_size, font) do
    text_sizes_and_font_families =
      TailwindSetting.get_form_options("typography", "font-size", nil, nil).form_configs ++
        TailwindSetting.get_form_options("typography", "font-family", nil, nil).form_configs

    Enum.reject(
      classes,
      &(&1 in text_sizes_and_font_families)
    ) ++
      [TailwindSetting.find_font_by_index(font_size).font_class] ++
      if(font != "" and !is_nil(font), do: [font], else: [])
  end
end
