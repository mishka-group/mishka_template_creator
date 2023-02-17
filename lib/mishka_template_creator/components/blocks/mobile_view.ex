defmodule MishkaTemplateCreator.Components.Blocks.MobileView do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_mobile_view(map) :: Phoenix.LiveView.Rendered.t()
  def block_mobile_view(assigns) do
    ~H"""
    <Heroicons.device_phone_mobile class={@custom_class} />
    """
  end
end
