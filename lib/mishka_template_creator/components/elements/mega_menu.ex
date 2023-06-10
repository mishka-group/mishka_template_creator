defmodule MishkaTemplateCreator.Components.Elements.MegaMenu do
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
        submit: submit,
        form: "goz"
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
    <nav
      data-type="mega_menu"
      id={"mega_menu-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      dir={@element["direction"] || "LTR"}
      class={@element["class"]}
    >
      <a
        href={@element["children"]["logo"]["link"]}
        class={@element["children"]["logo"]["link_class"]}
      >
        <img
          src={@element["children"]["logo"]["image"]}
          class={@element["children"]["logo"]["image_class"]}
          alt={@element["children"]["logo"]["alt"]}
        />
        <span class={@element["children"]["logo"]["title_class"]}>
          <%= @element["children"]["logo"]["title"] %>
        </span>
      </a>
      <div class="flex items-center md:order-2">
        <a
          :for={
            {%{id: _key, data: data}, _index} <-
              Enum.with_index(
                MishkaCoreComponent.sorted_list_by_order(
                  @element["menu_order"],
                  @element["children"]["menu"]
                )
              )
          }
          href={data["link"]}
          class={data["link_class"]}
        >
          <%= data["title"] %>
        </a>
        <button type="button" class={@element["mobile_button_class"]}>
          <span class="sr-only">Open main menu</span>
          <Heroicons.bars_3 class="w-6 h-6" />
        </button>
      </div>
      <div
        id="mega-menu"
        class="items-center justify-between hidden w-full md:flex md:w-auto md:order-1"
      >
        <ul class="flex flex-col mt-4 font-medium md:flex-row md:space-x-8 md:mt-0">
          <li :for={
            {%{id: key, data: data}, _index} <-
              Enum.with_index(
                MishkaCoreComponent.sorted_list_by_order(
                  @element["mega_menu_order"],
                  @element["children"]["mega_menu"]
                )
              )
          }>
            <a
              :if={length(data["order"]) == 0}
              href="#"
              class={@element["mega_menu_link_class"]}
              aria-current="page"
            >
              <%= data["title"] %>
            </a>
            <button
              :if={length(data["order"]) != 0}
              id={"mega-menu-dropdown-button-#{key}"}
              phx-click={JS.toggle(to: "#mega-menu-dropdown-#{key}")}
              class={@element["mega_menu_button_class"]}
            >
              <span><%= data["title"] %></span>
              <Heroicons.chevron_down class="w-5 h-5 ml-1" />
            </button>
            <div id={"mega-menu-dropdown-#{key}"} class="hidden">
              <div class="absolute mt-5 z-10 grid w-auto grid-cols-2 text-sm bg-white border border-gray-100 rounded-lg shadow-md md:grid-cols-3">
                <div
                  :for={
                    section <-
                      Enum.chunk_every(
                        MishkaCoreComponent.sorted_list_by_order(
                          data["order"],
                          data["children"]
                        ),
                        4
                      )
                  }
                  class="p-4 pb-0 text-gray-900 md:pb-4"
                >
                  <ul class="space-y-4" aria-labelledby="mega-menu-dropdown-button">
                    <li :for={%{id: _li_key, data: li_data} <- section}>
                      <a href="#" class="text-gray-500 hover:text-blue-600">
                        <%= li_data["title"] %>
                      </a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </nav>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"mega_menu-#{@id}"}>
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
          id={"mega_menu-#{@id}"}
          title="Logo Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
          open={false}
        >
          <MishkaCoreComponent.custom_simple_form
            :let={f}
            for={%{}}
            as={:mega_menu_component}
            phx-change="edit"
            phx-target={@myself}
            class="flex flex-col w-full justify-start gap-3 py-5"
          >
            <div class="flex flex-col justify-between items-center w-full gap-5">
              <div class="flex flex-row justify-between items-center w-full gap-5">
                <div class="flex flex-col gap-2 w-full">
                  <p class="font-bold text-sm">Title</p>
                  <%= text_input(f, :title,
                    class:
                      "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                    placeholder: "Change Title",
                    value: @element["children"]["logo"]["title"],
                    id: "mega-menu-logo-title"
                  ) %>
                </div>

                <div class="flex flex-col gap-2 w-full">
                  <p class="font-bold text-sm">Link</p>
                  <%= text_input(f, :link,
                    class:
                      "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                    placeholder: "Change Link",
                    value: @element["children"]["logo"]["link"],
                    id: "mega-menu-logo-link"
                  ) %>
                </div>
              </div>
              <div class="flex flex-col gap-2 w-full">
                <p class="font-bold text-sm">Image URL</p>
                <%= text_input(f, :image,
                  class:
                    "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                  placeholder: "Change image",
                  value: @element["children"]["logo"]["image"],
                  id: "mega-menu-logo-image"
                ) %>
              </div>

              <div class="flex flex-col gap-2 w-full">
                <p class="font-bold text-sm">Image URL</p>
                <%= text_input(f, :alt,
                  class:
                    "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                  placeholder: "Change description",
                  value: @element["children"]["logo"]["alt"],
                  id: "mega-menu-logo-description"
                ) %>
              </div>

              <.input field={f[:type]} type="hidden" value="logo" id={"logo-type-#{@id}-id"} />
            </div>
          </MishkaCoreComponent.custom_simple_form>
          <Text.font_style
            myself={@myself}
            classes={@element["children"]["logo"]["title_class"]}
            as={:mega_menu_logo_font_style}
            id={@id}
          />

          <Color.select
            event_name="mega_menu_logo_style"
            title="Logo Title Color:"
            myself={@myself}
            classes={@element["children"]["logo"]["title_class"]}
          />
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"mega_menu-#{@id}"}
          title="MegaMenu Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
          open={false}
        >
          <:before_title_block>
            <Heroicons.plus class="w-5 h-5 cursor-pointer" phx-click="add" phx-target={@myself} />
          </:before_title_block>

          <div class="w-full flex flex-col gap-3 space-y-4 pt-3">
            <span
              :if={length(@element["mega_menu_order"]) == 0}
              class="mx-auto border border-gray-200 bg-gray-100 font-bold py-2 px-3"
            >
              There is no menu item for this Mega Menu
            </span>

            <div
              :for={
                {%{id: key, data: data}, index} <-
                  Enum.with_index(
                    MishkaCoreComponent.sorted_list_by_order(
                      @element["mega_menu_order"],
                      @element["children"]["mega_menu"]
                    )
                  )
              }
              class="w-full flex flex-col justify-between items-center"
            >
              <div class="w-full flex flex-row justify-between items-center">
                <span
                  class="font-bold text-base select-none cursor-pointer"
                  id={"title-#{key}-#{index}"}
                  phx-click={JS.toggle(to: "#mega_menu-#{key}-#{index}")}
                >
                  <%= data["title"] %>
                </span>

                <div class="flex flex-row justify-end items-center gap-2">
                  <div
                    class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                    phx-click="add"
                    phx-value-id={key}
                    phx-target={@myself}
                  >
                    <Heroicons.plus class="w-5 h-5 cursor-pointer" />
                    <span class="text-base select-none">
                      Add
                    </span>
                  </div>
                  <div
                    class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                    phx-click={JS.toggle(to: "#mega_menu-#{key}-#{index}")}
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
                    phx-value-type="mega_menu"
                    phx-target={@myself}
                  >
                    <Heroicons.trash class="w-5 h-5 text-red-600" />
                    <span class="text-base select-none">Delete</span>
                  </div>
                </div>
              </div>

              <div id={"mega_menu-#{key}-#{index}"} class="hidden w-full">
                <MishkaCoreComponent.custom_simple_form
                  :let={f}
                  for={%{}}
                  as={:mega_menu_component}
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

                  <.input
                    field={f[:key]}
                    type="hidden"
                    value={key}
                    id={"navigation-#{key}-#{index}-id"}
                  />

                  <.input
                    field={f[:type]}
                    type="hidden"
                    value="mega_menu"
                    id={"navigation--type-#{key}-#{index}-id"}
                  />
                </MishkaCoreComponent.custom_simple_form>
              </div>

              <div
                :if={length(data["order"]) != 0}
                class="flex flex-col w-full justify-start gap-3 p-5 border border-gray-200 mt-3 rounded-md"
              >
                <div
                  :for={
                    {%{id: li_key, data: li_data}, index} <-
                      Enum.with_index(
                        MishkaCoreComponent.sorted_list_by_order(
                          data["order"],
                          data["children"]
                        )
                      )
                  }
                  class="w-full flex flex-col justify-between items-center"
                >
                  <div class="w-full flex flex-row justify-between items-center">
                    <span
                      class="text-base select-none cursor-pointer"
                      id={"title-#{li_key}-#{index}"}
                      phx-click={JS.toggle(to: "#mega_menu-#{li_key}-#{index}")}
                    >
                      <%= li_data["title"] %>
                    </span>

                    <div class="flex flex-row justify-end items-center gap-2">
                      <div
                        class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                        phx-click={JS.toggle(to: "#mega_menu-#{li_key}-#{index}")}
                      >
                        <Heroicons.pencil_square class="w-5 h-5" />
                        <span class="text-base select-none">
                          Edit
                        </span>
                      </div>
                      <div
                        class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                        phx-click="delete"
                        phx-value-id={li_key}
                        phx-value-parent-id={key}
                        phx-value-type="sub_mega_menu"
                        phx-target={@myself}
                      >
                        <Heroicons.trash class="w-5 h-5 text-red-600" />
                        <span class="text-base select-none">Delete</span>
                      </div>
                    </div>
                  </div>

                  <div id={"mega_sub_menu-#{li_key}-#{index}"} class="hidden w-full">
                    <MishkaCoreComponent.custom_simple_form
                      :let={f}
                      for={%{}}
                      as={:mega_menu_component}
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
                            value: li_data["title"],
                            id: "title-#{li_key}-#{index}-field"
                          ) %>
                        </div>

                        <div class="flex flex-col gap-2 w-full">
                          <p class="font-bold text-sm">Link</p>
                          <%= text_input(f, :link,
                            class:
                              "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                            placeholder: "Change Link",
                            value: li_data["link"],
                            id: "image-#{li_key}-#{index}-field"
                          ) %>
                        </div>
                      </div>

                      <.input
                        field={f[:key]}
                        type="hidden"
                        value={li_key}
                        id={"navigation-sub-#{li_key}-#{index}-id"}
                      />

                      <.input
                        field={f[:parent_id]}
                        type="hidden"
                        value={key}
                        id={"navigation-sub-#{li_key}-#{index}-parent_id"}
                      />

                      <.input
                        field={f[:type]}
                        type="hidden"
                        value="sub_mega_menu"
                        id={"navigation-sub-#{key}-#{index}-type"}
                      />
                    </MishkaCoreComponent.custom_simple_form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"menu-#{@id}"}
          title="Menu Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
          open={false}
        >
          <:before_title_block>
            <Heroicons.plus
              class="w-5 h-5 cursor-pointer"
              phx-click="add"
              phx-value-type="menu"
              phx-target={@myself}
            />
          </:before_title_block>

          <div class="w-full flex flex-col gap-3 space-y-4 pt-3">
            <span
              :if={length(@element["menu_order"]) == 0}
              class="mx-auto border border-gray-200 bg-gray-100 font-bold py-2 px-3"
            >
              There is no item for this Menu side
            </span>

            <div
              :for={
                {%{id: key, data: data}, index} <-
                  Enum.with_index(
                    MishkaCoreComponent.sorted_list_by_order(
                      @element["menu_order"],
                      @element["children"]["menu"]
                    )
                  )
              }
              class="w-full flex flex-col justify-between items-center"
            >
              <div class="w-full flex flex-row justify-between items-center">
                <span
                  class="font-bold text-base select-none cursor-pointer"
                  id={"title-#{key}-#{index}"}
                  phx-click={JS.toggle(to: "#mega_menu-#{key}-#{index}")}
                >
                  <%= data["title"] %>
                </span>

                <div class="flex flex-row justify-end items-center gap-2">
                  <div
                    class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                    phx-click={JS.toggle(to: "#mega_menu-#{key}-#{index}")}
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
                    phx-value-type="menu"
                    phx-target={@myself}
                  >
                    <Heroicons.trash class="w-5 h-5 text-red-600" />
                    <span class="text-base select-none">Delete</span>
                  </div>
                </div>
              </div>

              <div id={"mega_menu-#{key}-#{index}"} class="hidden w-full">
                <MishkaCoreComponent.custom_simple_form
                  :let={f}
                  for={%{}}
                  as={:mega_menu_component}
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
                  <div class="flex flex-col w-full items-center justify-center">
                    <ul class="flex flex-row mx-auto text-md border-gray-400 py-5 text-gray-600">
                      <li
                        class={"#{create_border_radius(data["link_class"], "rounded-none")} px-3 py-1 border border-gray-300 rounded-l-md border-r-0 hover:bg-gray-200 cursor-pointer"}
                        phx-click="border_radius"
                        phx-value-type="rounded-none"
                        phx-value-id={key}
                        phx-target={@myself}
                      >
                        None
                      </li>
                      <li
                        class={"#{create_border_radius(data["link_class"], "rounded-sm")} px-3 py-1 border border-gray-300 hover:bg-gray-200 cursor-pointer"}
                        phx-click="border_radius"
                        phx-value-type="rounded-sm"
                        phx-value-id={key}
                        phx-target={@myself}
                      >
                        SM
                      </li>
                      <li
                        class={"#{create_border_radius(data["link_class"], "rounded-md")} px-3 py-1 border border-gray-300 border-l-0 hover:bg-gray-200 cursor-pointer"}
                        phx-click="border_radius"
                        phx-value-type="rounded-md"
                        phx-value-id={key}
                        phx-target={@myself}
                      >
                        MD
                      </li>
                      <li
                        class={"#{create_border_radius(data["link_class"], "rounded-lg")} px-3 py-1 border border-gray-300 rounded-r-md border-l-0 hover:bg-gray-200 cursor-pointer"}
                        phx-click="border_radius"
                        phx-value-type="rounded-lg"
                        phx-value-id={key}
                        phx-target={@myself}
                      >
                        LG
                      </li>
                    </ul>
                  </div>
                  <.input
                    field={f[:key]}
                    type="hidden"
                    value={key}
                    id={"navigation-#{key}-#{index}-id"}
                  />

                  <.input
                    field={f[:type]}
                    type="hidden"
                    value="menu"
                    id={"navigation-type-#{key}-#{index}-type"}
                  />
                </MishkaCoreComponent.custom_simple_form>
                <Text.font_style
                  myself={@myself}
                  classes={data["link_class"]}
                  as={:menu_font_style}
                  id_input={key}
                  id={key}
                />

                <Color.select
                  event_name="menu_select_color"
                  title="Menu Font Color:"
                  myself={@myself}
                  classes={data["link_class"]}
                  id={key}
                />

                <Color.select
                  event_name="menu_select_color_bg"
                  id={key}
                  title="Menu Background Color:"
                  myself={@myself}
                  type="bg"
                  classes={data["link_class"]}
                />
              </div>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"mega_menu-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion
            id={"mega_menu-#{@id}"}
            title="Direction and Menus Style"
            open={false}
          >
            <Text.direction_selector myself={@myself} />

            <Text.font_style
              myself={@myself}
              classes={@element["class"]}
              as={:mega_menu_menu_font_style}
              id={@id}
            />

            <Color.select
              event_name="select_color_font"
              title="Font Color:"
              myself={@myself}
              classes={@element["class"]}
            />

            <Color.select
              title="Background Color:"
              type="bg"
              myself={@myself}
              classes={@element["class"]}
            />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"mega_menu-#{@id}"} title="Custom Tag name" open={false}>
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

  def handle_event("add", %{"type" => "menu"}, socket) do
    unique_id = Ecto.UUID.generate()

    updated =
      socket.assigns.element
      |> update_in(["children", "menu"], fn selected_element ->
        Map.merge(selected_element, %{
          "#{unique_id}" => %{
            "link" => "#",
            "title" => "New Title",
            "link_class" => [
              "text-gray-800",
              "hover:bg-gray-50",
              "focus:ring-4",
              "focus:ring-gray-300",
              "font-medium",
              "rounded-lg",
              "text-sm",
              "px-4",
              "py-2",
              "md:px-5",
              "md:py-2.5",
              "mr-1",
              "md:mr-2",
              "focus:outline-none"
            ]
          }
        })
      end)
      |> Map.merge(%{
        "menu_order" => socket.assigns.element["menu_order"] ++ [unique_id]
      })
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("add", %{"id" => id}, socket) do
    unique_id = Ecto.UUID.generate()

    updated =
      socket.assigns.element
      |> update_in(["children", "mega_menu", id, "children"], fn selected_element ->
        Map.merge(selected_element, %{
          "#{unique_id}" => %{
            "link" => "#",
            "title" => "New Title"
          }
        })
      end)
      |> update_in(["children", "mega_menu", id], fn selected_element ->
        selected_element
        |> Map.merge(%{
          "order" => selected_element["order"] ++ [unique_id]
        })
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("add", _params, socket) do
    unique_id = Ecto.UUID.generate()

    updated =
      socket.assigns.element
      |> update_in(["children", "mega_menu"], fn selected_element ->
        Map.merge(selected_element, %{
          "#{unique_id}" => %{
            "link" => "#",
            "title" => "New Title",
            "children" => %{},
            "order" => []
          }
        })
      end)
      |> Map.merge(%{
        "mega_menu_order" => socket.assigns.element["mega_menu_order"] ++ [unique_id]
      })
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "edit",
        %{
          "mega_menu_component" => %{
            "type" => "mega_menu",
            "title" => title,
            "link" => link,
            "key" => id
          }
        },
        socket
      ) do
    updated =
      socket.assigns.element
      |> update_in(["children", "mega_menu", id], fn selected_element ->
        Map.merge(selected_element, %{"title" => title, "link" => link})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "edit",
        %{
          "mega_menu_component" =>
            %{
              "type" => "logo",
              "title" => _title,
              "link" => _link,
              "image" => _image,
              "alt" => _alt
            } = params
        },
        socket
      ) do
    updated =
      socket.assigns.element
      |> update_in(["children", "logo"], fn selected_element ->
        Map.merge(selected_element, Map.drop(params, ["type"]))
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "edit",
        %{
          "mega_menu_component" => %{
            "type" => "sub_mega_menu",
            "title" => title,
            "link" => link,
            "key" => id,
            "parent_id" => parent_id
          }
        },
        socket
      ) do
    updated =
      socket.assigns.element
      |> update_in(["children", "mega_menu", parent_id, "children", id], fn selected_element ->
        Map.merge(selected_element, %{"title" => title, "link" => link})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "edit",
        %{
          "mega_menu_component" => %{
            "type" => "menu",
            "title" => title,
            "link" => link,
            "key" => id
          }
        },
        socket
      ) do
    updated =
      socket.assigns.element
      |> update_in(["children", "menu", id], fn selected_element ->
        Map.merge(selected_element, %{"title" => title, "link" => link})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"mega_menu_icon_style" => %{"height" => height, "width" => width}},
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

  def handle_event("mega_menu_icon_font_style", %{"color" => color}, socket) do
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

  def handle_event("mega_menu_title_font_style", %{"color" => color}, socket) do
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

  def handle_event("mega_menu_border_style", %{"color" => color}, socket) do
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

  def handle_event("menu_select_color", %{"color" => color, "id" => id}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    updated =
      socket.assigns.element
      |> update_in(["children", "menu", id], fn selected_element ->
        IO.inspect(selected_element)
        class = Enum.reject(selected_element["link_class"], &(&1 in text_colors)) ++ [color]
        Map.merge(selected_element, %{"link_class" => class})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("menu_select_color_bg", %{"color" => color, "id" => id}, socket) do
    bg_colors =
      TailwindSetting.get_form_options("backgrounds", "background-color", nil, nil).form_configs

    updated =
      socket.assigns.element
      |> update_in(["children", "menu", id], fn selected_element ->
        class = Enum.reject(selected_element["link_class"], &(&1 in bg_colors)) ++ [color]
        Map.merge(selected_element, %{"link_class" => class})
      end)
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
        %{"mega_menu_title_font_style" => %{"font" => font, "font_size" => font_size}},
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
        %{"mega_menu_menu_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class = Text.edit_font_style_class(socket.assigns.element["class"], font_size, font)

    updated =
      socket.assigns.element
      |> Map.merge(%{"class" => class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"mega_menu_logo_font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    class =
      Text.edit_font_style_class(
        socket.assigns.element["children"]["logo"]["title_class"],
        font_size,
        font
      )

    updated =
      socket.assigns.element
      |> update_in(["children", "logo"], fn selected_element ->
        Map.merge(selected_element, %{"title_class" => class})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "font_style",
        %{"menu_font_style" => %{"font" => font, "font_size" => font_size, "id" => id}},
        socket
      ) do
    IO.inspect(id)

    updated =
      socket.assigns.element
      |> update_in(["children", "menu", id], fn selected_element ->
        class = Text.edit_font_style_class(selected_element["link_class"], font_size, font)

        Map.merge(selected_element, %{"link_class" => class})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("mega_menu_menu_link_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["menu_link_class"], &(&1 in text_colors)) ++ [color]

    icon_class =
      Enum.reject(socket.assigns.element["icon_class"], &(&1 in text_colors)) ++ [color]

    updated =
      socket.assigns.element
      |> Map.merge(%{"menu_link_class" => class, "icon_class" => icon_class})
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("mega_menu_logo_style", %{"color" => color}, socket) do
    text_colors =
      TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["children"]["logo"]["title_class"], &(&1 in text_colors)) ++
        [color]

    updated =
      socket.assigns.element
      |> update_in(["children", "logo"], fn selected_element ->
        Map.merge(selected_element, %{"title_class" => class})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("select_color_font", %{"color" => color}, socket) do
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

  def handle_event("select_color", %{"color" => color}, socket) do
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

  def handle_event(
        "font_style",
        %{"mega_menu_menu_icon_style" => %{"height" => height, "width" => width}},
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
           TailwindSetting.default_element("mega_menu")
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("border_radius", %{"type" => type, "id" => id}, socket) do
    borders = TailwindSetting.get_form_options("borders", "border-radius", nil, nil).form_configs

    updated =
      socket.assigns.element
      |> update_in(["children", "menu", id], fn selected_element ->
        class = Enum.reject(selected_element["link_class"], &(&1 in borders)) ++ [type]
        Map.merge(selected_element, %{"link_class" => class})
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("delete", %{"type" => "mega_menu", "id" => id}, socket) do
    {_, elements} = pop_in(socket.assigns.element, ["children", "mega_menu", id])

    updated =
      elements
      |> Map.merge(%{
        "mega_menu_order" => Enum.reject(socket.assigns.element["mega_menu_order"], &(&1 == id))
      })
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event(
        "delete",
        %{"type" => "sub_mega_menu", "parent-id" => parent_id, "id" => id},
        socket
      ) do
    {_, elements} =
      pop_in(socket.assigns.element, ["children", "mega_menu", parent_id, "children", id])

    updated =
      elements
      |> update_in(["children", "mega_menu", parent_id], fn selected_element ->
        selected_element
        |> Map.merge(%{
          "order" => Enum.reject(selected_element["order"], &(&1 == id))
        })
      end)
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("delete", %{"type" => "menu", "id" => id}, socket) do
    {_, elements} = pop_in(socket.assigns.element, ["children", "menu", id])

    updated =
      elements
      |> Map.merge(%{
        "menu_order" => Enum.reject(socket.assigns.element["menu_order"], &(&1 == id))
      })
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

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
