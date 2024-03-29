defmodule MishkaTemplateCreator.Components.Layout.History do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    new_sock = push_event(socket, "create_sample_html", %{myself: socket.assigns.myself.cid})
    {:ok, assign(new_sock, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>Back To/History</div>
    """
  end

  @impl true
  def handle_event("save", %{"html" => html}, socket) do
    # TODO: It should check directory exists
    # TODO: Create html file
    # name should be selected by user
    Path.join("deployment", ["templates/test1.html"])
    |> File.write(html)

    {:noreply, socket}
  end
end
