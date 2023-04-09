defmodule MishkaTemplateCreator.Components.ConfigSelector do
  use Phoenix.LiveComponent
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias Phoenix.LiveView.JS

  @impl true
  def mount(socket) do
    {:ok, push_event(socket, "clean_extra_config", %{})}
  end

  @impl true
  def update(assigns, socket) do
    new_sock = push_event(socket, "set_extra_config", %{id: assigns.id})
    {:ok, assign(new_sock, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="ConfigSelectorComponent">
      <form phx-change="query" phx-target={@myself}>
        <input
          class="border !border-gray-300 rounded-md w-full mx-0 my-0 focus:text-black focus:ring-2 focus:ring-orange-300 focus:!border-transparent z-20"
          id={"select_search-#{@id}"}
          name="select_search"
          type="search"
          autocomplete="off"
          phx-click={JS.focus(to: "#select_search-#{@id}")}
        />

        <input type="hidden" id={"#{@id}-myself"} name="myself" value={@myself} />
      </form>

      <div :if={!is_nil(@class)} class="flex flex-wrap my-2 gap-2">
        <div
          :for={item <- @class}
          :if={TailwindSetting.is_class?(item, @selected_setting.form_configs, :is_section)}
          class="flex flex-row justify-start items-start py-1 px-3 bg-gray-200 rounded-md gap-2 text-black text-sm"
        >
          <span><%= "#{item}" %></span>
          <Heroicons.trash
            class="search-select-icons mt-1"
            phx-click="delete"
            phx-value-config={item}
            phx-target={@myself}
          />
        </div>
      </div>

      <div
        id={"config-#{@id}"}
        class="flex flex-col mt-2 border border-gray-300 rounded-md px-4 py-2 mb-2 min-h-[9rem] max-h-36 overflow-y-scroll"
      >
        <p
          :for={item <- Enum.take(@selected_setting.form_configs, 10)}
          class="cursor-pointer px-1 py-1 duration-200 hover:bg-gray-300 hover:rounded-md hover:duration-100 text-black text-sm"
          phx-click="select"
          phx-value-config={item}
          phx-target={@myself}
          phx-value-myself={@myself}
        >
          <%= item %>
        </p>
      </div>
      <span class="text-blue-400 mt-4 text-xs hover:text-blue-500">
        There are
        <span id={"count-config-#{@id}"}><%= length(@selected_setting.form_configs) %></span>
        results for this section, please find by searching ...
      </span>

      <div class="flex flex-wrap w-full gap-2 text-center justify-start items-center mt-3 text-black">
        <span
          :for={item <- TailwindSetting.type_create(@selected_setting.types)}
          class={"#{@id}-extra-config-#{item} #{if item == :none, do: "bg-gray-200"} cursor-pointer border border-gray-300 p-1 w-10 rounded-md text-xs hover:bg-gray-200 hover:duration-150 duration-300"}
          phx-click="set_extra_config"
          phx-value-config={item}
          phx-target={@myself}
        >
          <%= item %>
        </span>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("query", %{"select_search" => value, "myself" => myself}, socket) do
    form_configs = socket.assigns.selected_setting.form_configs

    results =
      form_configs
      |> Enum.filter(&String.contains?(&1, value))

    {:noreply,
     push_event(socket, "show_selected_results", %{
       results: results |> Enum.take(10),
       id: "config-#{socket.assigns.id}",
       myself: myself,
       count: length(results)
     })}
  end

  def handle_event("select", %{"config" => config, "myself" => myself}, socket) do
    {:noreply, push_event(socket, "get_extra_config", %{config: config, myself: myself})}
  end

  def handle_event("delete", %{"config" => config}, socket) do
    %{block_id: block_id, block_type: block_type} = socket.assigns.selected_setting

    send(
      self(),
      {"delete",
       %{
         "block_id" => block_id,
         "block_type" => block_type,
         "config" => config,
         "parent_id" => socket.assigns.parent_id
       }}
    )

    {:noreply, socket}
  end

  def handle_event("save", %{"extra_config" => extra_config, "config" => config}, socket) do
    %{block_id: block_id, block_type: block_type} = socket.assigns.selected_setting

    send(
      self(),
      {"element",
       %{
         "block_id" => block_id,
         "block_type" => block_type,
         "extra_config" => extra_config,
         "config" => config,
         "parent_id" => socket.assigns.parent_id
       }}
    )

    {:noreply, socket}
  end

  def handle_event("set_extra_config", %{"config" => config}, socket) do
    {:noreply, push_event(socket, "set_extra_config", %{config: config, id: socket.assigns.id})}
  end
end
