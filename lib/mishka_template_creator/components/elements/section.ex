defmodule MishkaTemplateCreator.Components.Elements.Section do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  alias MishkaTemplateCreator.Components.Blocks.{
    Settings,
    AddSeparator,
    Delete,
    Tag
  }

  attr(:id, :string, required: true)
  attr(:parent_id, :string, required: true)
  attr(:selected_block, :string, required: true)
  attr(:selected_setting, :map, required: true)
  attr(:tag, :string, default: nil)
  attr(:order, :list, required: true)
  attr(:submit, :boolean, default: false)
  attr(:on_delete, JS, default: %JS{})
  attr(:on_duplicate, JS, default: %JS{})
  attr(:children, :map, default: %{})
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @spec section(map) :: Phoenix.LiveView.Rendered.t()
  def section(assigns) do
    ~H"""
    <div
      class={"group relative #{Enum.join(@class, " ")} #{if @selected_block === @id, do: "bg-white rounded-sm"}"}
      id={@id}
      data-type="section"
      phx-click="set"
      phx-value-id={@id}
      phx-value-type="section"
      data-type="section"
      data-parent-type="layout,section"
      data-id={@id}
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

      <.element
        :for={
          %{id: key, data: data} <- Enum.map(@order, fn key -> %{id: key, data: @children[key]} end)
        }
        id={key}
        element={data}
        type={data["type"]}
      />
    </div>
    """
  end

  attr(:section_id, :string, required: true)
  attr(:parent_id, :string, required: true)
  attr(:submit, :boolean, default: false)
  attr(:selected_setting, :map, required: true)
  attr(:class, :string, default: nil)

  @spec section_header(map) :: Phoenix.LiveView.Rendered.t()
  defp section_header(assigns) do
    ~H"""
    <div
      id={"section_header_#{@section_id}"}
      class="section-header"
      data-type="section"
      data-parent-type="layout"
      data-id={@section_id}
    >
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

  attr(:id, :string, required: true)
  attr(:element, :map, required: true)
  attr(:on_delete, JS, default: %JS{})
  attr(:on_duplicate, JS, default: %JS{})
  attr(:rest, :global)

  def element(%{rest: %{type: type}} = assigns) do
    module_converted_name =
      if String.contains?(type, "_") do
        String.split(type, "_")
        |> Enum.map(&String.capitalize(&1))
        |> Enum.join()
      else
        String.capitalize(type)
      end

    atom_created =
      Module.safe_concat(
        "Elixir.MishkaTemplateCreator.Components.Elements",
        module_converted_name
      )

    assigns = assign(assigns, :block_module, atom_created)

    ~H"""
    <.live_component
      module={@block_module}
      id={@id  <> "-call"}
      element={@element}
      render_type="call"
    />
    """
  rescue
    _e ->
      ~H"""

      """
  end
end
