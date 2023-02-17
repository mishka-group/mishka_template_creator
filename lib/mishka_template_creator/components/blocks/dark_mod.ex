defmodule MishkaTemplateCreator.Components.Blocks.DarkMod do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_dark_mod(map) :: Phoenix.LiveView.Rendered.t()
  def block_dark_mod(assigns) do
    ~H"""
    <Heroicons.sun class={@custom_class} />
    """
  end
end
