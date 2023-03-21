defmodule MishkaTemplateCreator.Components.ConfigSelector do
  use Phoenix.LiveComponent
  alias MishkaTemplateCreator.Data.TailwindSetting

  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="ConfigSelectorComponent">
      <form phx-change="query" phx-target={@myself}>
        <input
          class="border !border-gray-300 rounded-md w-full mx-0 my-0 focus:text-black focus:ring-2 focus:ring-orange-300 focus:!border-transparent"
          id={"select_search-#{@id}"}
          name="select_search"
          type="search"
          phx-click="click"
          phx-target={@myself}
          autocomplete="off"
        />

        <input type="hidden" id="myself" name="myself" value={@myself} />
      </form>

      <div class="flex flex-wrap my-2 gap-2">
        <div
          :for={item <- [1, 2, 3]}
          class="flex flex-row justify-start items-start py-1 px-3 bg-gray-200 rounded-md gap-2 text-black text-sm"
        >
          <span><%= "h-#{item}" %></span>
          <Heroicons.trash class="search-select-icons mt-1" phx-click="delete" phx-target={@myself} />
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
        >
          <%= item %>
        </p>
      </div>
      <span class="text-blue-400 mt-4 text-xs hover:text-blue-500">
        There are <%= length(@selected_setting.form_configs) %> results for this section, please find by searching ...
      </span>

      <div class="flex flex-wrap w-full gap-2 text-center justify-start items-center mt-3 text-black">
        <span
          :for={item <- TailwindSetting.type_create(@selected_setting.types)}
          class="cursor-pointer border border-gray-300 p-1 w-10 rounded-md text-xs hover:bg-gray-200 hover:duration-150 duration-300"
          phx-click="extra_config"
          phx-value-config={item}
          phx-target={@myself}
        >
          <%= item %>
        </span>
      </div>
    </div>
    """
  end

  def handle_event("click", %{"value" => _value}, socket) do
    {:noreply, socket}
  end

  def handle_event("query", %{"select_search" => value, "myself" => myself}, socket) do
    form_configs = socket.assigns.selected_setting.form_configs

    results =
      form_configs
      |> Enum.filter(&String.contains?(&1, value))
      |> Enum.take(10)

    {:noreply,
     push_event(socket, "show_selected_results", %{
       results: results,
       id: "config-#{socket.assigns.id}",
       myself: myself
     })}
  end

  def handle_event("select", %{"config" => config}, socket) do
    IO.inspect(config)
    {:noreply, socket}
  end

  def handle_event("delete", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  def handle_event("extra_config", %{"config" => config}, socket) do
    IO.inspect(config)
    {:noreply, socket}
  end
end
