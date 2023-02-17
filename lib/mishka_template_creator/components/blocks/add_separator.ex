defmodule MishkaTemplateCreator.Components.Blocks.AddSeparator do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_add_separator(map) :: Phoenix.LiveView.Rendered.t()
  def block_add_separator(assigns) do
    ~H"""
    <Heroicons.plus class={@custom_class} />
    """
  end
end
