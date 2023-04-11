defmodule MishkaTemplateCreator.Components.Blocks.ElementMenu do
  use Phoenix.Component
  alias MishkaTemplateCreator.Data.Elements

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :parent_type, :string, required: true
  attr :rest, :global

  slot :inner_block, required: true

  @spec block_menu(map) :: Phoenix.LiveView.Rendered.t()
  def block_menu(assigns) do
    ~H"""
    <div
      data-id={@id}
      data-type={@id}
      data-parent-type={@parent_type}
      class="border border-gray-200 rounded-md p-5 hover:border hover:border-blue-300 hover:duration-300 duration-1000 hover:text-blue-500 lg:px-1"
      {@rest}
    >
      <p class="mx-auto text-center">
        <%= render_slot(@inner_block) %>
      </p>
      <p class="text-xs font-bold mt-5 text-center"><%= @title %></p>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :items, :list, required: true
  attr :title, :string, required: true

  @spec items(map) :: Phoenix.LiveView.Rendered.t()
  def items(assigns) do
    ~H"""
    <div id={@id} class="flex flex-col px-2 py-4 mx-auto w-full">
      <h3 class="mb-4 font-bold"><%= @title %></h3>
      <div
        id={"#{@id}-block"}
        class="grid grid-cols-3 gap-4 text-gray-700 lg:grid-cols-3 2xl:grid-cols-4"
      >
        <.block_menu
          :for={{id, title, module, parent_type} <- @items}
          id={id}
          title={title}
          parent_type={Enum.join(parent_type, ",")}
        >
          <.icon module={module} />
        </.block_menu>
      </div>
    </div>
    """
  end

  @spec aside_menu(any) :: Phoenix.LiveView.Rendered.t()
  def aside_menu(assigns) do
    assigns =
      assign(assigns,
        layout_items: Elements.elements(:layout_items),
        elements_items: Elements.elements(:elements_items),
        media_items: Elements.elements(:media_items)
      )

    ~H"""
    <.items id="layout" items={Elements.elements(:layout_items)} title="Layout" />
    <hr />
    <.items id="elements" items={Elements.elements(:elements_items)} title="Elements" />
    <hr />
    <.items id="media" items={Elements.elements(:media_items)} title="Media" />
    """
  end

  attr :module, :string, required: true

  defp icon(assigns) do
    ~H"""
    <%= Phoenix.LiveView.TagEngine.component(
      Code.eval_string("&#{@module}/1") |> elem(0),
      [class: "w-6 h-6 mx-auto stroke-current"],
      {__ENV__.module, __ENV__.function, __ENV__.file, __ENV__.line}
    ) %>
    """
  end
end
