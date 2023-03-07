defmodule MishkaTemplateCreator.Components.Blocks.ElementMenu do
  use Phoenix.Component

  @layout_items [
    {"layout", "Layout", "Heroicons.inbox_stack"},
    {"section", "Section", "Heroicons.inbox_stack"},
    {"text", "Text", "Heroicons.inbox_stack"},
    {"tabs", "Tabs", "Heroicons.inbox_stack"},
    {"columns", "Columns", "Heroicons.inbox_stack"},
    {"table", "Table", "Heroicons.inbox_stack"},
    {"accordion", "Accordion", "Heroicons.inbox_stack"}
  ]
  @elements_items [
    {"alerts", "Alerts", "Heroicons.inbox_stack"},
    {"quotes", "Quotes", "Heroicons.inbox_stack"},
    {"buttons", "Buttons", "Heroicons.inbox_stack"},
    {"links", "Links", "Heroicons.inbox_stack"},
    {"code", "Code", "Heroicons.inbox_stack"},
    {"notes", "Notes", "Heroicons.inbox_stack"}
  ]
  @media_items [
    {"image", "Image", "Heroicons.inbox_stack"},
    {"video", "Video", "Heroicons.inbox_stack"},
    {"gallery", "Gallery", "Heroicons.inbox_stack"},
    {"thumbnails", "Thumbnails", "Heroicons.inbox_stack"},
    {"audio", "Audio", "Heroicons.inbox_stack"},
    {"file", "File", "Heroicons.inbox_stack"},
    {"pdf", "PDF", "Heroicons.inbox_stack"},
    {"comparison", "Comparison", "Heroicons.inbox_stack"}
  ]

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :rest, :global

  slot :inner_block, required: true

  @spec block_menu(map) :: Phoenix.LiveView.Rendered.t()
  def block_menu(assigns) do
    ~H"""
    <div
      data-id={@id}
      data-type={@id}
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
        <.block_menu :for={{id, title, module} <- @items} id={id} title={title}>
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
        layout_items: @layout_items,
        elements_items: @elements_items,
        media_items: @media_items
      )

    ~H"""
    <.items id="layout" items={@layout_items} title="Layout" />
    <hr />
    <.items id="elements" items={@elements_items} title="Elements" />
    <hr />
    <.items id="media" items={@media_items} title="Media" />
    """
  end

  attr :module, :string, required: true

  defp icon(assigns) do
    ~H"""
    <%= Phoenix.LiveView.HTMLEngine.component(
      Code.eval_string("&#{@module}/1") |> elem(0),
      [class: "w-6 h-6 mx-auto stroke-current"],
      {__ENV__.module, __ENV__.function, __ENV__.file, __ENV__.line}
    ) %>
    """
  end
end