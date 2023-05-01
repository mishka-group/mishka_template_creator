defmodule MishkaTemplateCreator.Components.Elements.Avatar do
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
      data-type="avatar"
      id={"avatar-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      dir={@element["direction"] || "LTR"}
      class={@element["class"]}
    >
      <div :for={
        %{id: _key, data: data} <-
          MishkaCoreComponent.sorted_list_by_order(@element["order"], @element["children"])
      }>
        <img
          :if={data["image"] != "" and data["text"] == ""}
          }
          class={@element["image_class"]}
          src={data["image"]}
          alt={data["alt"]}
        />
        <a :if={data["image"] == "" and data["text"] != ""} class={@element["text_class"]} href="#">
          <%= data["text"] %>
        </a>
      </div>
    </div>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"avatar-#{@id}"}>
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
          id={"avatar-#{@id}"}
          title="Avatar Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <:before_title_block>
            <Heroicons.plus
              class="w-5 h-5 cursor-pointer"
              phx-click="add"
              phx-value-type="avatar"
              phx-target={@myself}
            />
          </:before_title_block>

          <div class="w-full flex flex-col gap-3 space-y-4 pt-3">
            <span
              :if={length(@element["order"]) == 0}
              class="mx-auto border border-gray-200 bg-gray-100 font-bold py-2 px-3"
            >
              There is no avatar item for this section
            </span>

            <div
              :for={
                {%{id: key, data: data}, index} <-
                  Enum.with_index(
                    MishkaCoreComponent.sorted_list_by_order(
                      @element["order"],
                      @element["children"]
                    ),
                    1
                  )
              }
              class="w-full flex flex-col justify-normal"
            >
              <div class="w-full flex flex-row justify-between items-center">
                <span class="font-bold text-base">
                  Avatar-<%= index %>
                </span>

                <div class="flex flex-row justify-end items-center gap-2">
                  <div
                    class="flex flex-row justify-center items-start gap-2 cursor-pointer"
                    phx-click={
                      JS.toggle(to: "#avatar-common-avatar-#{key}")
                      |> JS.toggle(to: "#avatar-common-close-#{key}")
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
                    phx-value-type="avatar"
                    phx-value-id={key}
                    phx-target={@myself}
                  >
                    <Heroicons.trash class="w-5 h-5 text-red-600" />
                    <span class="text-base select-none">Delete</span>
                  </div>
                </div>
              </div>

              <div id={"avatar-common-avatar-#{key}"} class="w-full hidden">
                <MishkaCoreComponent.custom_simple_form
                  :let={f}
                  for={%{}}
                  as={:avatar_avatar}
                  phx-change="edit"
                  phx-target={@myself}
                  class="flex flex-col w-full justify-start gap-2"
                >
                  <div class="flex flex-col gap-2 w-full my-5">
                    <span class="font-bold text-sm">Title:</span>
                    <%= text_input(f, :title,
                      class:
                        "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                      placeholder: "Change avatar name",
                      value: data["title"],
                      id: "input-title-#{key}"
                    ) %>
                  </div>
                  <div class="flex flex-col gap-2 w-full">
                    <span class="font-bold text-sm">Hyperlink:</span>
                    <%= text_input(f, :hyperlink,
                      class:
                        "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
                      placeholder: "Change avatar hyperlink",
                      value: data["hyperlink"],
                      id: "input-hyperlink-#{key}"
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
                        selected: data["target"],
                        class:
                          "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2",
                        id: "input-target-#{key}"
                      ) %>
                    </div>

                    <div class="flex flex-col gap-2 w-full">
                      <span class="font-bold text-sm">Nofollow:</span>
                      <%= select(f, :nofollow, [true, false],
                        selected: data["nofollow"],
                        class:
                          "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2",
                        id: "input-nofollow-#{key}"
                      ) %>
                    </div>

                    <.input field={f[:id]} type="hidden" value={key} id={"input-id-#{key}"} />
                  </div>
                </MishkaCoreComponent.custom_simple_form>
                <div class="grid grid-cols-3 gap-2 w-full my-5 pt-2 items-center">
                  sss
                </div>
              </div>
              <p
                id={"avatar-common-close-#{key}"}
                class="text-blue-400 my-2 w-full text-center hidden"
                phx-click={
                  JS.toggle(to: "#avatar-common-avatar-#{key}")
                  |> JS.toggle(to: "#avatar-common-close-#{key}")
                }
              >
                Close this settings
              </p>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion
          id={"avatar-#{@id}"}
          title="Public Settings"
          title_class="my-4 w-full text-center font-bold select-none text-lg"
        >
          <Aside.aside_accordion id={"table-#{@id}"} title="Alignment" open={false}>
            <Text.direction_selector myself={@myself} />
          </Aside.aside_accordion>

          <Aside.aside_accordion id={"avatar-#{@id}"} title="Custom Tag name" open={false}>
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

  def handle_event("add", %{"type" => "avatar"}, socket) do
    unique_id = Ecto.UUID.generate()
    avatars = TailwindSetting.default_element("avatar")
    first_avatars = avatars["children"][List.first(avatars["order"])]

    updated =
      socket.assigns.element
      |> update_in(["children"], fn selected_children ->
        Map.merge(selected_children, %{"#{unique_id}" => first_avatars})
      end)
      |> Map.merge(%{"order" => socket.assigns.element["order"] ++ [unique_id]})
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

  def handle_event("reset", _params, socket) do
    send(
      self(),
      {"element",
       %{
         "update_parame" =>
           TailwindSetting.default_element("avatar")
           |> Map.merge(socket.assigns.selected_form)
       }}
    )

    {:noreply, socket}
  end

  def handle_event("delete", %{"type" => "avatar", "id" => id}, socket) do
    {_, elements} = pop_in(socket.assigns.element, ["children", id])

    updated =
      Map.merge(elements, %{
        "order" => Enum.reject(socket.assigns.element["order"], &(&1 == id))
      })
      |> Map.merge(socket.assigns.selected_form)

    send(self(), {"element", %{"update_parame" => updated}})

    {:noreply, socket}
  end

  def handle_event("delete", _params, socket) do
    send(self(), {"delete", %{"delete_element" => socket.assigns.selected_form}})

    {:noreply, socket}
  end
end
