defmodule MishkaTemplateCreator.Components.MultiSelectComponent do
  use Phoenix.LiveComponent

  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="MultiSelectComponent">
      <form phx-change="query" phx-target={@myself}>
        <input
          class="border !border-gray-300 rounded-md w-full mx-0 my-0 focus:text-black focus:ring-2 focus:ring-orange-300 focus:!border-transparent"
          id="select_search"
          name="select_search"
          type="search"
          phx-click="click"
          phx-target={@myself}
        />
      </form>

      <div class="flex flex-wrap my-2 gap-2">
        <div
          :for={item <- [1, 2, 3]}
          class="flex flex-row justify-start items-start py-1 px-3 bg-gray-200 rounded-md gap-2"
        >
          <span><%= "h-#{item}" %></span>
          <Heroicons.trash class="search-select-icons mt-1" phx-click="delete" phx-target={@myself} />
        </div>
      </div>

      <div class="flex flex-col mt-2 border border-gray-300 rounded-md px-4 py-2 mb-2">
        <p
          :for={item <- [1, 2, 3, 4]}
          class="cursor-pointer px-1 py-1 duration-200 hover:bg-gray-300 hover:rounded-md hover:duration-100"
        >
          select item <%= item %>
        </p>
      </div>
      <span class="text-blue-400 mt-4 text-xs hover:text-blue-500">
        There are 180 results for this section, please find by searching ...
      </span>

      <div class="flex flex-wrap w-full gap-2 text-center justify-start items-center mt-3">
        <span
          :for={size <- [:none, :sm, :md, :lg, :xl, :"2xl", :dark, :hover]}
          class="border border-gray-300 p-1 w-10 rounded-md text-xs hover:bg-gray-200 hover:duration-150 duration-300"
        >
          <%= size %>
        </span>
      </div>
    </div>
    """
  end

  def handle_event("click", %{"value" => value}, socket) do
    IO.inspect(value)
    {:noreply, socket}
  end

  def handle_event("query", %{"select_search" => value}, socket) do
    IO.inspect(socket.assigns.selected_setting)
    {:noreply, push_event(socket, "show_select_result", %{points: value})}
  end

  def handle_event("select", %{"value" => value}, socket) do
    IO.inspect(value)
    {:noreply, socket}
  end

  def handle_event("delete", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
