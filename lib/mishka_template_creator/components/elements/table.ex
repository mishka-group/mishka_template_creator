defmodule MishkaTemplateCreator.Components.Elements.Table do
  use Phoenix.LiveComponent
  use Phoenix.Component
  import Phoenix.HTML.Form
  import MishkaTemplateCreatorWeb.CoreComponents

  alias MishkaTemplateCreator.Components.Layout.Aside
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias Phoenix.LiveView.JS
  alias MishkaTemplateCreator.Components.Blocks.Tag
  alias MishkaTemplateCreator.Components.Blocks.Color

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
          <thead
            class={@element["header"]["row"]}
            dir={@element["header_direction"] || @element["direction"] || "LTR"}
          >
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
          <tbody dir={@element["content_direction"] || @element["direction"] || "LTR"}>
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
          title="Table Header Content"
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
            <span
              :if={length(@element["children"]["headers"]) == 0}
              class="mx-auto border border-gray-200 bg-gray-100 font-bold py-2 px-3"
            >
              There is no header item for this table
            </span>

            <div
              :for={{title, index} <- Enum.with_index(@element["children"]["headers"])}
              class="w-full flex flex-row justify-between items-center"
            >
              <span
                class="font-bold text-base"
                id={"title-#{@id}-#{index}-span-title"}
                phx-click={JS.toggle() |> JS.toggle(to: "#title-#{@id}-#{index}")}
              >
                <%= title %>
              </span>
              <div id={"title-#{@id}-#{index}"} class="hidden">
                <MishkaCoreComponent.custom_simple_form
                  :let={f}
                  for={%{}}
                  as={:table_header_component}
                  phx-submit="edit"
                  phx-target={@myself}
                  class="flex flex-row w-full justify-start gap-2"
                >
                  <%= text_input(f, :title,
                    class:
                      "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                    placeholder: "Change Tag name",
                    value: title,
                    id: "title-#{@id}-#{index}-title-text"
                  ) %>

                  <.input
                    field={f[:index]}
                    type="hidden"
                    value={index}
                    id={"title-#{@id}-#{index}-title-id"}
                  />

                  <button
                    type="submit"
                    class="px-4 py-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700"
                    phx-click={
                      JS.toggle(to: "#title-#{@id}-#{index}-span-title")
                      |> JS.toggle(to: "#title-#{@id}-#{index}")
                    }
                  >
                    Save
                  </button>
                </MishkaCoreComponent.custom_simple_form>
              </div>

              <div class="flex flex-row justify-end items-center gap-2">
                <div
                  class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                  phx-click={
                    JS.toggle(to: "#title-#{@id}-#{index}-span-title")
                    |> JS.toggle(to: "#title-#{@id}-#{index}")
                  }
                >
                  <Heroicons.pencil_square class="w-5 h-5" />
                  <span class="text-base select-none">
                    Edit
                  </span>
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
          title="Table Row Content"
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
            <span
              :if={Map.keys(@element["children"]["content"]) == []}
              class="mx-auto border border-gray-200 bg-gray-100 font-bold py-2 px-3"
            >
              Please add row for this table
            </span>

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
                    phx-click={
                      JS.show(to: "#table-content-#{@id}-#{key}")
                      |> JS.push("add_item", value: %{"type" => "content", "id" => key})
                    }
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
                    phx-target={@myself}
                  >
                    <Heroicons.trash class="w-5 h-5 text-red-600" />
                    <span class="text-base select-none">Delete</span>
                  </div>
                </div>
              </div>
              <div id={"table-content-#{@id}-#{key}"} class={"w-full #{if index != 1, do: "hidden"}"}>
                <div class="w-full flex flex-wrap p-3 gap-2 items-start">
                  <span
                    :if={length(data) == 0}
                    class="mx-auto border border-gray-200 bg-gray-100 font-bold py-2 px-3"
                  >
                    Please add items for this row
                  </span>
                  <span
                    :for={{item, index} <- Enum.with_index(data)}
                    class="group text-sm border border-gray-200 rounded-md py-2 px-3 bg-gray-100 relative mb-3"
                  >
                    <span id={"content-title-#{@id}-#{index}"}><%= item %></span>

                    <div id={"content-title-input-#{@id}-#{index}"} class="hidden">
                      <MishkaCoreComponent.custom_simple_form
                        :let={f}
                        for={%{}}
                        as={:table_content_component}
                        phx-submit="edit"
                        phx-target={@myself}
                        class="flex flex-row w-full justify-start gap-2"
                      >
                        <%= text_input(f, :title,
                          class:
                            "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                          placeholder: "Change Tag name",
                          value: item,
                          id: "content-title-form-#{@id}-#{index}"
                        ) %>

                        <.input
                          field={f[:index]}
                          type="hidden"
                          value={index}
                          id={"content-id-form-#{@id}-#{index}"}
                        />

                        <.input
                          field={f[:id]}
                          type="hidden"
                          value={key}
                          id={"content-key-form-#{@id}-#{index}"}
                        />

                        <button
                          type="submit"
                          class="px-4 py-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700"
                          phx-click={
                            JS.toggle(to: "#content-title-input-#{@id}-#{index}")
                            |> JS.toggle(to: "#content-title-#{@id}-#{index}")
                          }
                        >
                          Save
                        </button>
                      </MishkaCoreComponent.custom_simple_form>
                    </div>
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
                        phx-click={
                          JS.toggle(to: "#content-title-input-#{@id}-#{index}")
                          |> JS.toggle(to: "#content-title-#{@id}-#{index}")
                        }
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
          title="Table Header Style"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"table-headers-#{@id}"} title="Header Font Style" open={false}>
            <MishkaCoreComponent.alignment_selector
              event_name="header_text_alignment"
              myself={@myself}
            />

            <MishkaCoreComponent.direction_selector
              event_name="header_text_direction"
              myself={@myself}
            />

            <MishkaCoreComponent.custom_simple_form
              :let={f}
              for={%{}}
              as={:header_table_font_style}
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
                        @element["header"]["row"],
                        &(&1 in TailwindSetting.get_form_options(
                            "typography",
                            "font-family",
                            nil,
                            nil
                          ).form_configs)
                      ),
                    id: "header_table_font-#{@id}"
                  ) %>
                </div>
              </div>
              <div class="flex flex-row w-full justify-between items-stretch pt-3 pb-5">
                <span class="w-3/5">Size:</span>
                <div class="flex flex-row w-full gap-2 items-center">
                  <span class="py-1 px-2 border border-gray-300 text-xs rounded-md">
                    <%= TailwindSetting.find_text_size_index(@element["header"]["row"]).index %>
                  </span>
                  <%= range_input(f, :font_size,
                    min: "1",
                    max: "13",
                    value: TailwindSetting.find_text_size_index(@element["header"]["row"]).index,
                    class: "w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer",
                    id: "header_table_font_size-#{@id}"
                  ) %>
                </div>
              </div>
            </MishkaCoreComponent.custom_simple_form>
            <Color.select
              myself={@myself}
              event_name="header_table_row_text_style"
              classes={@element["header"]["row"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"table-headers-#{@id}"} title="Header Row Style" open={false}>
            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              event_name="header_table_row_style"
              classes={@element["header"]["row"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"table-headers-#{@id}"} title="Header Item Style" open={false}>
            <Color.select
              title="Text Color:"
              myself={@myself}
              event_name="header_table_item_text_style"
              classes={@element["header"]["column"]}
            />

            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              event_name="header_table_item_style"
              classes={@element["header"]["column"]}
            />
          </Aside.aside_accordion>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"table-#{@id}"}
          title="Table Row Style"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"table-row-#{@id}"} title="Row Font Style" open={false}>
            <MishkaCoreComponent.alignment_selector event_name="row_text_alignment" myself={@myself} />

            <MishkaCoreComponent.direction_selector event_name="row_text_direction" myself={@myself} />
            <MishkaCoreComponent.custom_simple_form
              :let={f}
              for={%{}}
              as={:content_table_font_style}
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
                        @element["content"]["row"],
                        &(&1 in TailwindSetting.get_form_options(
                            "typography",
                            "font-family",
                            nil,
                            nil
                          ).form_configs)
                      ),
                    id: "content_tab_font-#{@id}"
                  ) %>
                </div>
              </div>
              <div class="flex flex-row w-full justify-between items-stretch pt-3 pb-5">
                <span class="w-3/5">Size:</span>
                <div class="flex flex-row w-full gap-2 items-center">
                  <span class="py-1 px-2 border border-gray-300 text-xs rounded-md">
                    <%= TailwindSetting.find_text_size_index(@element["content"]["row"]).index %>
                  </span>
                  <%= range_input(f, :font_size,
                    min: "1",
                    max: "13",
                    value: TailwindSetting.find_text_size_index(@element["content"]["row"]).index,
                    class: "w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer",
                    id: "content_tab_font_size-#{@id}"
                  ) %>
                </div>
              </div>
            </MishkaCoreComponent.custom_simple_form>
            <Color.select
              myself={@myself}
              event_name="content_table_row_text_style"
              classes={@element["content"]["row"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"table-headers-#{@id}"} title="Row Row Style" open={false}>
            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              event_name="content_table_row_style"
              classes={@element["content"]["row"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"table-headers-#{@id}"} title="Row Item Style" open={false}>
            <Color.select
              title="Text Color:"
              myself={@myself}
              event_name="content_table_item_text_style"
              classes={@element["content"]["column"]}
            />

            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              event_name="content_table_item_style"
              classes={@element["content"]["column"]}
            />
          </Aside.aside_accordion>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"table-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"table-#{@id}"} title="Alignment" open={false}>
            <MishkaCoreComponent.alignment_selector myself={@myself} />

            <MishkaCoreComponent.direction_selector myself={@myself} />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"table-#{@id}"} title="Font Style" open={false}>
            <MishkaCoreComponent.custom_simple_form
              :let={f}
              for={%{}}
              as={:public_table_font_style}
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
            <Color.select
              myself={@myself}
              event_name="public_table_font_style"
              classes={@element["class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"table-#{@id}"} title="Custom Tag name" open={false}>
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

  def handle_event("header_text_alignment", %{"type" => type}, socket)
      when type in ["start", "center", "end", "justify"] do
    text_aligns =
      TailwindSetting.get_form_options("typography", "text-align", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["header"]["row"], &(&1 in text_aligns)) ++
        ["text-#{type}"]

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "row" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("row_text_alignment", %{"type" => type}, socket)
      when type in ["start", "center", "end", "justify"] do
    text_aligns =
      TailwindSetting.get_form_options("typography", "text-align", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["content"]["row"], &(&1 in text_aligns)) ++
        ["text-#{type}"]

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => %{socket.assigns.element["content"] | "row" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("header_text_direction", %{"type" => type}, socket)
      when type in ["RTL", "LTR"] do
    send(
      self(),
      {"element",
       %{
         "update_parame" =>
           %{
             "key" => "header_direction",
             "value" => type
           }
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("row_text_direction", %{"type" => type}, socket)
      when type in ["RTL", "LTR"] do
    send(
      self(),
      {"element",
       %{
         "update_parame" =>
           %{
             "key" => "content_direction",
             "value" => type
           }
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"public_table_font_style" => %{"font" => font, "font_size" => font_size}},
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

  def handle_event(
        "font_style",
        %{"header_table_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class = edit_font_style_class(socket.assigns.element["header"]["row"], font_size, font)

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "row" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"content_table_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class = edit_font_style_class(socket.assigns.element["content"]["row"], font_size, font)

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => %{socket.assigns.element["content"] | "row" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("public_table_font_style", %{"color" => color}, socket) do
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

  def handle_event(
        "edit",
        %{"table_header_component" => %{"title" => title, "index" => index}},
        socket
      ) do
    index = String.to_integer(index)

    updated =
      socket.assigns.element
      |> update_in(["children", "headers"], fn selected_element ->
        Enum.with_index(selected_element)
        |> Enum.map(fn
          {_, ^index} -> title
          {value, _} -> value
        end)
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "edit",
        %{"table_content_component" => %{"title" => title, "index" => index, "id" => id}},
        socket
      ) do
    index = String.to_integer(index)

    updated =
      socket.assigns.element
      |> update_in(["children", "content", id], fn selected_element ->
        Enum.with_index(selected_element)
        |> Enum.map(fn
          {_, ^index} -> title
          {value, _} -> value
        end)
      end)
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

  def handle_event("add", %{"type" => "content"}, socket) do
    unique_id = Ecto.UUID.generate()

    updated =
      socket.assigns.element
      |> update_in(["children", "content"], fn selected_element ->
        Map.merge(selected_element, %{
          "#{unique_id}" => []
        })
      end)
      |> Map.merge(%{"order" => socket.assigns.element["order"] ++ [unique_id]})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("add_item", %{"type" => "content", "id" => id}, socket) do
    updated =
      socket.assigns.element
      |> update_in(["children", "content", id], fn selected_element ->
        selected_element ++ ["New Item"]
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("header_table_row_style", %{"color" => color}, socket) do
    bg_colors =
      TailwindSetting.get_form_options("backgrounds", "background-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["header"]["row"], &(&1 in bg_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "row" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("header_table_item_style", %{"color" => color}, socket) do
    bg_colors =
      TailwindSetting.get_form_options("backgrounds", "background-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["header"]["column"], &(&1 in bg_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "column" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("content_table_row_style", %{"color" => color}, socket) do
    bg_colors =
      TailwindSetting.get_form_options("backgrounds", "background-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["content"]["row"], &(&1 in bg_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => %{socket.assigns.element["content"] | "row" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("content_table_item_style", %{"color" => color}, socket) do
    bg_colors =
      TailwindSetting.get_form_options("backgrounds", "background-color", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["content"]["column"], &(&1 in bg_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => %{socket.assigns.element["content"] | "column" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("header_table_row_text_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["header"]["row"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "row" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("header_table_item_text_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["header"]["column"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"header" => %{socket.assigns.element["header"] | "column" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("content_table_item_text_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["content"]["column"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => %{socket.assigns.element["content"] | "column" => class}})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("content_table_row_text_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class = Enum.reject(socket.assigns.element["content"]["row"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"content" => %{socket.assigns.element["content"] | "row" => class}})
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

  def handle_event("delete", %{"type" => "content", "id" => id}, socket) do
    {_, element} = pop_in(socket.assigns.element, ["children", "content", id])

    updated =
      element
      |> Map.merge(%{"order" => Enum.reject(element["order"], &(&1 == id))})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("delete", _params, socket) do
    send(self(), {"delete", %{"delete_element" => socket.assigns.selected_form}})

    {:noreply, socket}
  end

  def handle_event(
        "delete_item",
        %{"type" => "content_item", "index" => index, "id" => id},
        socket
      ) do
    updated =
      socket.assigns.element
      |> update_in(["children", "content", id], fn selected_element ->
        List.delete_at(selected_element, String.to_integer(index))
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

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
