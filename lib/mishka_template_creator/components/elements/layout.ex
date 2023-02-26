defmodule MishkaTemplateCreator.Components.Elements.Layout do
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  alias MishkaTemplateCreator.Components.Elements.Section

  alias MishkaTemplateCreator.Components.Blocks.{
    AddSeparator,
    DarkMod,
    Delete,
    MobileView,
    Settings,
    ShowMore,
    Tag
  }

  attr :id, :string, required: true
  attr :selected_block, :string, required: true
  attr :tag, :string, default: nil
  attr :submit, :boolean, default: false
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}
  attr :children, :list, default: []

  @spec layout(map) :: Phoenix.LiveView.Rendered.t()
  def layout(assigns) do
    ~H"""
    <div class="create-layout group" id={"layout-#{@id}"} data-type="layout">
      <div class="flex flex-row justify-start items-center space-x-3 absolute -left-[2px] -top-11 bg-gray-200 border border-gray-200 p-2 rounded-tr-3xl z-1 w-54">
        <MobileView.block_mobile_view block_id={@id} />
        <DarkMod.block_dark_mod block_id={@id} />
        <Settings.block_settings block_id={@id} />
        <Tag.block_tag block_id={@id} submit={@submit} />
        <div :if={@tag}><strong>Tag: </strong><%= @tag %></div>
        <AddSeparator.block_add_separator block_id={@id} />
        <Delete.delete_block block_id={@id} />
        <ShowMore.block_more block_id={@id} />
      </div>
      <div
        id={@id}
        class={"flex flex-row justify-start items-center w-full space-x-3 px-3 #{if length(@children) == 0, do: "py-10"}"}
        data-type="layout"
      >
        <Section.section
          :for={child <- @children}
          id={child.id}
          children={child.children}
          selected_block={@selected_block}
          parent_id={@id}
          submit={@submit}
          tag={Map.get(child, :tag)}
        />
      </div>
    </div>
    """
  end
end
