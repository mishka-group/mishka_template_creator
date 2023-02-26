defmodule MishkaTemplateCreator.Components.Blocks.Tag do
  use Phoenix.Component
  import MishkaTemplateCreatorWeb.CoreComponents
  alias Phoenix.LiveView.JS

  attr :block_id, :string, required: true
  attr :type, :string, required: false, default: "layout"
  attr :parent_id, :string, required: false, default: nil
  attr :submit, :boolean, default: false
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_tag(map) :: Phoenix.LiveView.Rendered.t()
  def block_tag(assigns) do
    ~H"""
    <Heroicons.tag class={@custom_class} phx-click={show_modal("#{@type}-tag-#{@block_id}")} />
    <.modal id={"#{@type}-tag-#{@block_id}"}>
      <.simple_form for={%{}} as={:tag} phx-submit="save_tag" phx-change="validate_tag">
        <.input name="tag" label="Tag Name" id={"field-tag-#{@type}-#{@block_id}"} value=""/>
        <p class={"text-sm #{if @submit, do: "text-red-500", else: ""}"}>
          Please use only letters and numbers in naming and also keep in mind that you can only use (<code class="text-pink-400">-</code>) between letters. It should be noted, the tag name must be more than 4 characters.
        </p>
        <.input
          name="type"
          type="hidden"
          value={@type}
          id={"field-type-#{@type}-#{@block_id}"}
        />
        <.input
          name="id"
          type="hidden"
          value={@block_id}
          id={"field-id-#{@type}-#{@block_id}"}
        />
        <.input
          name="parent_id"
          type="hidden"
          value={@parent_id}
          id={"field-parent_id-#{@type}-#{@block_id}"}
        />
        <:actions>
          <.button
            class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 disabled:bg-gray-400 disabled:text-white disabled:outline-none"
            disabled={@submit}
            phx-click={if !@submit, do: hide_modal("#{@type}-tag-#{@block_id}"), else: nil}
          >
            Save
          </.button>
        </:actions>
      </.simple_form>
    </.modal>
    """
  end
end
