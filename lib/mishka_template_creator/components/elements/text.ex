defmodule MishkaTemplateCreator.Components.Elements.Text do
  use Phoenix.LiveComponent
  alias MishkaTemplateCreator.Components.Blocks.Aside
  import Phoenix.HTML.Form

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(%{render_type: "call"} = assigns) do
    ~H"""
    <div
      data-type="text"
      id={"text-#{@id}"}
      phx-click="get_element_layout_id"
      phx-value-myself={@myself}
      phx-target={@myself}
      class={@element.class}
    >
      <%= Map.get(@element, :html) || "This is a predefined text. Please click on the text to edit." %>
    </div>
    """
  end

  @impl true
  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>
      <Aside.aside_settings id={"text-#{@id}"}>
        <Aside.aside_accordion id={"text-#{@id}"} title="Change Text">
          <div class="flex flex-col w-full items-center justify-center pb-5">
            <%= textarea(:text_component, :text,
              class:
                "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
              id: "#{Ecto.UUID.generate()}",
              rows: "4"
            ) %>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion id={"text-#{@id}"} title="Alignment">
          <div class="flex flex-col w-full items-center justify-center">
            <ul class="flex flex-row mx-auto text-md border-gray-400 py-5 text-gray-600">
              <li class="px-3 py-1 border border-gray-300 rounded-l-md border-r-0 hover:bg-gray-200 cursor-pointer">
                <Heroicons.bars_3_center_left class="w-6 h-6" />
              </li>
              <li class="px-3 py-1 border border-gray-300 hover:bg-gray-200 cursor-pointer">
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
              <li class="px-3 py-1 border border-gray-300 border-l-0 hover:bg-gray-200 cursor-pointer">
                <Heroicons.bars_3_bottom_right class="w-6 h-6" />
              </li>
              <li class="px-3 py-1 border border-gray-300 rounded-r-md border-l-0 hover:bg-gray-200 cursor-pointer">
                <Heroicons.bars_3 class="w-6 h-6" />
              </li>
            </ul>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion id={"text-#{@id}"} title="Font Style">
          <div class="flex flex-row w-full justify-between items-stretch pt-3 pb-5">
            <span class="w-3/5">Font:</span>
            <div class="w-full">
              <select
                id="countries"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-1"
              >
                <option selected>Choose a font</option>
                <option value="US">United States</option>
                <option value="CA">Canada</option>
                <option value="FR">France</option>
                <option value="DE">Germany</option>
              </select>
            </div>
          </div>
          <div class="flex flex-row w-full justify-between items-stretch pt-3 pb-5">
            <span class="w-3/5">Size:</span>
            <div class="w-full">
              <input
                id="Size"
                type="range"
                min="1"
                max="48"
                value="10"
                class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
              />
            </div>
          </div>
          <div class="flex flex-row w-full justify-between items-stretch pt-3 pb-5">
            <span class="w-3/5">Color:</span>
            <div class="w-full">
              <%= color_input(:text_component, :color,
                id: "#{Ecto.UUID.generate()}",
                placeholder: "Change Tag name"
              ) %>
            </div>
          </div>
        </Aside.aside_accordion>

        <Aside.aside_accordion id={"text-#{@id}"} title="Custom Tag name">
          <div class="flex flex-col w-full items-center justify-center pb-5">
            <%= text_input(:text_component, :tag,
              class:
                "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500",
              id: "#{Ecto.UUID.generate()}",
              placeholder: "Change Tag name"
            ) %>
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
        id: socket.assigns.element.parent_id,
        myself: myself
      })

    {:noreply, new_sock}
  end

  def handle_event("set_element_form", %{"layout_id" => layout_id}, socket) do
    %{parent_id: section_id, id: element_id, type: element_type} = socket.assigns.element

    send(
      self(),
      {"set_element_form",
       %{
         element_id: element_id,
         element_type: element_type,
         layout_id: layout_id,
         section_id: section_id
       }}
    )

    {:noreply, socket}
  end
end
