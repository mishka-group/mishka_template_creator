defmodule MishkaTemplateCreator.Components.Elements.Text do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  alias MishkaTemplateCreator.Components.Blocks.Aside
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  alias MishkaTemplateCreator.Data.TailwindSetting

  @selected_text_color [
    "text-black",
    "text-slate-600",
    "text-slate-700",
    "text-slate-800",
    "text-slate-900",
    "text-gray-700",
    "text-gray-800",
    "text-gray-900",
    "text-zinc-800",
    "text-zinc-900",
    "text-neutral-900",
    "text-neutral-800",
    "text-stone-700",
    "text-stone-800",
    "text-stone-900"
  ]

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
       submit: submit,
       selected_text_color: @selected_text_color
     )}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(%{render_type: "call"} = assigns) do
    ~H"""
    <div
      data-type="text"
      id={"text-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      class={@element["class"]}
      dir={@element["direction"] || "LTR"}
    >
      <%= @element["html"] || "This is a predefined text. Please click on the text to edit." %>
    </div>
    """
  end

  @impl true
  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"text-#{@id}"}>
        <div class="text-sm font-medium text-center text-gray-500 border-b border-gray-200 items-center mx-auto mb-4">
          <ul class="flex flex-wrap -mb-px items-center">
            <li class="mr-2">
              <a
                href="#"
                class="inline-block p-4 text-blue-600 border-b-2 border-blue-600 rounded-t-lg"
                aria-current="page"
              >
                Quick edit
              </a>
            </li>
            <li class="mr-2">
              <a
                href="#"
                class="inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300 active"
              >
                Advanced edit
              </a>
            </li>
          </ul>
        </div>

        <Aside.aside_accordion id={"text-#{@id}"} title="Change Text">
          <MishkaCoreComponent.custom_simple_form
            :let={f}
            for={%{}}
            as={:text_edit}
            phx-change="text_edit"
            phx-target={@myself}
            class="w-full m-0 p-0 flex flex-col"
          >
            <div class="flex flex-col w-full items-center justify-center pb-5">
              <%= textarea(f, :text,
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
          </MishkaCoreComponent.custom_simple_form>
        </Aside.aside_accordion>

        <Aside.aside_accordion id={"text-#{@id}"} title="Alignment">
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

        <Aside.aside_accordion id={"text-#{@id}"} title="Font Style">
          <MishkaCoreComponent.custom_simple_form
            :let={f}
            for={%{}}
            as={:font_style}
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
                  prompt: "Choose your preferred font",
                  selected:
                    Enum.find(
                      @element["class"],
                      &(&1 in TailwindSetting.get_form_options("typography", "font-family", nil, nil).form_configs)
                    )
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
                  class: "w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
                ) %>
              </div>
            </div>
          </MishkaCoreComponent.custom_simple_form>
          <div class="flex flex-col w-full justify-between items-stretch pt-3 pb-5">
            <span class="w-full">Color:</span>
            <div class="flex flex-wrap w-full mt-4">
              <div
                :for={
                  item <-
                    TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs
                }
                :if={item not in ["text-inherit", "text-current", "text-transparent"]}
                class={"bg-#{String.replace(item, "text-", "")} w-4 h-4 cursor-pointer"}
                phx-click="font_style"
                phx-value-color={item}
                phx-target={@myself}
              >
                <Heroicons.x_mark
                  :if={item in @element["class"]}
                  class={if(item in @selected_text_color, do: "text-white")}
                />
              </div>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion id={"text-#{@id}"} title="Custom Tag name">
          <div class="flex flex-col w-full items-center justify-center pb-5">
            <MishkaCoreComponent.custom_simple_form
              :let={f}
              for={%{}}
              as={:text_component}
              phx-change="validate"
              phx-submit="element"
              phx-target={@myself}
              class="w-full m-0 p-0 flex flex-col"
            >
              <%= text_input(f, :tag,
                class:
                  "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                placeholder: "Change Tag name",
                value: @element["tag"]
              ) %>
              <p class={"text-xs #{if @submit, do: "text-red-500", else: ""} my-3 text-justify"}>
                Please use only letters and numbers in naming and also keep in mind that you can only use (<code class="text-pink-400">-</code>) between letters. It should be noted, the tag name must be more than 4 characters.
              </p>
            </MishkaCoreComponent.custom_simple_form>
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

  def handle_event("validate", %{"text_component" => %{"tag" => tag}}, socket) do
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

  def handle_event(
        "font_style",
        %{"font_style" => %{"font" => font, "font_size" => font_size}},
        socket
      ) do
    text_sizes_and_font_families =
      TailwindSetting.get_form_options("typography", "font-size", nil, nil).form_configs ++
        TailwindSetting.get_form_options("typography", "font-family", nil, nil).form_configs

    class =
      Enum.reject(socket.assigns.element["class"], &(&1 in text_sizes_and_font_families)) ++
        [TailwindSetting.find_font_by_index(font_size).font_class] ++
        if(font != "", do: [font], else: [])

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

  def handle_event("font_style", %{"color" => color}, socket) do
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

  def handle_event("text_edit", %{"text_edit" => %{"text" => text}}, socket) do
    send(
      self(),
      {"element",
       %{
         "update_parame" =>
           %{
             "key" => "html",
             "value" => text
           }
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

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
end
