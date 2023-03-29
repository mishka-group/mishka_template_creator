defmodule MishkaTemplateCreator.Components.Elements.Section do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  alias MishkaTemplateCreator.Components.Blocks.{
    Settings,
    AddSeparator,
    Delete,
    Tag
  }

  attr :id, :string, required: true
  attr :parent_id, :string, required: true
  attr :selected_block, :string, required: true
  attr :selected_setting, :map, required: true
  attr :tag, :string, default: nil
  attr :submit, :boolean, default: false
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}
  attr :rest, :global
  attr :children, :list, default: []
  attr :class, :string, default: nil

  @spec section(map) :: Phoenix.LiveView.Rendered.t()
  def section(assigns) do
    ~H"""
    <div
      class={"group relative #{Enum.join(@class, " ")} #{if @selected_block === @id, do: "bg-white rounded-sm"}"}
      id={@id}
      data-type="section"
      phx-click="edit_section"
      phx-value-id={@id}
    >
      <.section_header
        :if={@selected_block == @id}
        section_id={@id}
        parent_id={@parent_id}
        submit={@submit}
        selected_setting={@selected_setting}
        class={@class}
      />

      <div :if={@tag} class="section-tag">
        <strong>Tag:</strong>
        <%= @tag %>
      </div>

      <.element :for={child <- @children} type={child.type} id={child.id} />
    </div>
    """
  end

  attr :section_id, :string, required: true
  attr :parent_id, :string, required: true
  attr :submit, :boolean, default: false
  attr :selected_setting, :map, required: true
  attr :class, :string, default: nil

  @spec section_header(map) :: Phoenix.LiveView.Rendered.t()
  defp section_header(assigns) do
    ~H"""
    <div id={"section_header_#{@section_id}"} class="section-header">
      <Settings.block_settings
        block_id={@section_id}
        icon_class="section-icons"
        selected_setting={@selected_setting}
        type="section"
        class={@class}
        parent_id={@parent_id}
      />
      <Tag.block_tag
        block_id={@section_id}
        custom_class="section-icons"
        type="section"
        parent_id={@parent_id}
        submit={@submit}
      />
      <AddSeparator.block_add_separator block_id={@section_id} custom_class="section-icons" />
      <Delete.delete_block
        block_id={@section_id}
        custom_class="section-icons text-red-500"
        type="section"
        parent_id={@parent_id}
      />
    </div>
    """
  end

  attr :id, :string, required: true
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}
  attr :rest, :global

  def element(%{rest: %{type: type}} = assigns) do
    atom_created =
      Module.safe_concat(
        "Elixir.MishkaTemplateCreator.Components.Elements",
        String.capitalize(type)
      )

    assigns = assign(assigns, :block_module, atom_created)

    ~H"""
    <.live_component module={@block_module} id={@id} />
    """
  rescue
    _e ->
      ~H"""

      """
  end
end
