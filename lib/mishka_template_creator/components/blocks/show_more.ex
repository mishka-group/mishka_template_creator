defmodule MishkaTemplateCreator.Components.Blocks.ShowMore do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_more(map) :: Phoenix.LiveView.Rendered.t()
  def block_more(assigns) do
    ~H"""
    <Heroicons.ellipsis_vertical class={@custom_class} />
    """
  end
end
