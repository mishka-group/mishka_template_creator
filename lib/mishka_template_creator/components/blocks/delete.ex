defmodule MishkaTemplateCreator.Components.Blocks.Delete do
  use Phoenix.Component
  import MishkaTemplateCreatorWeb.CoreComponents
  alias Phoenix.LiveView.JS

  attr :block_id, :string, required: true
  attr :parent_id, :string, required: false, default: nil
  attr :type, :string, required: false, default: "layout"
  attr :custom_class, :string, required: false, default: "layout-icons text-red-500"
  attr :on_click, JS, default: %JS{}

  @spec delete_block(map) :: Phoenix.LiveView.Rendered.t()
  def delete_block(assigns) do
    ~H"""
    <Heroicons.trash class={@custom_class} phx-click={show_modal("delete_confirm-#{@block_id}")} />
    <.modal
      id={"delete_confirm-#{@block_id}"}
      on_confirm={
        JS.push("delete", value: %{id: @block_id, type: @type, parent_id: @parent_id})
        |> hide_modal("delete_confirm-#{@block_id}")
      }
    >
      Are you sure?
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>
    """
  end
end
