defmodule MishkaTemplateCreator.Components.Blocks.Settings do
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Components.Blocks.ElementMenu

  @tailwind_settings [
    {"layout", "Layout", "Heroicons.inbox_stack"},
    {"flexbox_grid", "Flexbox & Grid", "Heroicons.circle_stack"},
    {"spacing", "Spacing", "Heroicons.square_3_stack_3d"},
    {"sizing", "Sizing", "Heroicons.swatch"},
    {"typography", "Typography", "Heroicons.chat_bubble_bottom_center"},
    {"backgrounds", "Backgrounds", "Heroicons.window"},
    {"borders", "Borders", "Heroicons.bars_2"},
    {"effects", "Effects", "Heroicons.light_bulb"},
    {"filters", "Filters", "Heroicons.scissors"},
    {"tables", "Tables", "Heroicons.table_cells"},
    {"transitions_animation", "Transitions & Animation", "Heroicons.sparkles"},
    {"transforms", "Transforms", "Heroicons.rectangle_stack"},
    {"interactivity", "Interactivity", "Heroicons.paper_clip"},
    {"accessibility", "Accessibility", "Heroicons.eye"},
    {"svg", "SVG", "Heroicons.photo"}
  ]

  attr :block_id, :string, required: true
  attr :type, :string, required: false, default: "layout"
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_settings(map) :: Phoenix.LiveView.Rendered.t()
  def block_settings(assigns) do
    assigns = assign(assigns, :tailwind_settings, @tailwind_settings)

    ~H"""
    <Heroicons.wrench_screwdriver
      class={@custom_class}
      phx-click={show_modal("#{@type}-settings-#{@block_id}")}
    />
    <.modal id={"#{@type}-settings-#{@block_id}"}>
      <p class="text-center font-bold mb-4 text-lg">Please select the section you want to edit</p>
      <div class="grid grid-cols-3 gap-3 text-gray-500 mt-8 mb-10 md:grid-cols-4 lg:grid-cols-5">
        <ElementMenu.block_menu :for={{id, title, module} <- @tailwind_settings} id={id} title={title}>
          <%= Phoenix.LiveView.HTMLEngine.component(
            Code.eval_string("&#{module}/1") |> elem(0),
            [class: "w-6 h-6 mx-auto stroke-current"],
            {__ENV__.module, __ENV__.function, __ENV__.file, __ENV__.line}
          ) %>
        </ElementMenu.block_menu>
      </div>
      <p
        class="text-center text-sm text-blue-400"
        phx-click="add_custom_class"
        phx-value-id={@block_id}
        phx-value-type={@type}
      >
        <span>OR put your custom classes</span>
      </p>
    </.modal>
    """
  end
end
