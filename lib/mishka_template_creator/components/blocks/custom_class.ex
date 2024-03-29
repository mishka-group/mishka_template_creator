defmodule MishkaTemplateCreator.Components.Blocks.CustomClass do
  use Phoenix.LiveComponent
  import MishkaTemplateCreatorWeb.CoreComponents
  import Phoenix.HTML.Form

  alias MishkaTemplateCreator.Data.TailwindSetting
  alias Phoenix.LiveView.JS

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    new_sock = push_event(socket, "set_focus", %{customClasses: "custom-classes"})
    {:ok, assign(new_sock, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <p class="text-xs text-gray-400 text-center w-full mx-auto mt-4 mb-0 leading-4">
        In this section, you can edit or view all the classes selected for this block, and it is also possible to easily enter commands manually and quickly. Of course, this is more suitable for people who have mastered Tailwind.
      </p>

      <.simple_form :let={f} for={%{}} as={:custom_class} phx-change="add" phx-target={@myself}>
        <%= textarea(f, :custom_classes,
          label: "Custom Classes:",
          class: "custom-classes w-full",
          id: "#{Ecto.UUID.generate()}",
          value: Enum.join(@class, " "),
          phx_click: JS.focus()
        ) %>
        <.input field={f[:block_type]} type="hidden" value={@type} id={"#{Ecto.UUID.generate()}"} />
        <.input field={f[:block_id]} type="hidden" value={@block_id} id={"#{Ecto.UUID.generate()}"} />
      </.simple_form>

      <div :if={!is_nil(@class)} class="flex flex-wrap my-2 gap-2">
        <div
          :for={item <- @class}
          class="flex flex-row justify-start items-start py-1 px-3 bg-gray-200 rounded-md gap-2 text-black text-sm"
        >
          <span><%= "#{item}" %></span>
          <Heroicons.trash
            class="search-select-icons mt-1"
            phx-click="delete"
            phx-value-config={item}
            phx-value-block_id={@block_id}
            phx-value-block-type={@type}
            phx-target={@myself}
          />
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("add", %{"custom_class" => custom_class}, socket) do
    custom_class["custom_classes"]
    |> String.split(" ")
    |> Enum.map(&TailwindSetting.is_class?(&1, TailwindSetting.get_all_config()))
    |> Enum.member?(false)
    |> case do
      true ->
        nil

      _ ->
        send(
          self(),
          {"element",
           %{
             "update_class" => %{
               "id" => custom_class["block_id"],
               "type" => custom_class["block_type"],
               "parent_id" => socket.assigns.parent_id,
               "class" => custom_class["custom_classes"],
               "action" => :string_classes
             }
           }}
        )
    end

    {:noreply, socket}
  end

  def handle_event(
        "delete",
        %{"config" => config, "block-type" => block_type, "block-id" => block_id},
        socket
      ) do
    send(
      self(),
      {"delete",
       %{
         "delete_class" => %{
           "id" => block_id,
           "type" => block_type,
           "class" => config,
           "parent_id" => socket.assigns.parent_id
         }
       }}
    )

    {:noreply, socket}
  end
end
