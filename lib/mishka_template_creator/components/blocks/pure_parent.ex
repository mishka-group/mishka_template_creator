defmodule MishkaTemplateCreator.Components.Blocks.PureParent do
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <Heroicons.eye
        class="layout-icons"
        phx-click={JS.push("toggle_clean", value: %{block_id: @block_id})}
        phx-target={@myself}
      />
    </div>
    """
  end

  @impl true
  def handle_event("toggle_clean", %{"block_id" => block_id}, socket) do
    {:noreply, push_event(socket, "clean_layout_default_style", %{block_id: block_id})}
  end
end
