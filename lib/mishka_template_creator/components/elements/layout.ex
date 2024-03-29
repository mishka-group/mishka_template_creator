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
    Tag,
    PureParent
  }

  attr(:id, :string, required: true)
  attr(:selected_block, :map, required: true)
  attr(:selected_setting, :map, required: true)
  attr(:order, :list, required: true)
  attr(:tag, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:submit, :boolean, default: false)
  attr(:on_delete, JS, default: %JS{})
  attr(:on_duplicate, JS, default: %JS{})
  attr(:children, :map, default: %{})

  @spec layout(map) :: Phoenix.LiveView.Rendered.t()
  def layout(assigns) do
    ~H"""
    <div
      class="create-layout group"
      id={"container-#{@id}"}
      data-type="layout"
      data-parent-type="dragLocation"
      data-id={@id}
    >
      <div class="unsortable flex flex-row justify-start items-center space-x-3 absolute -left-[2px] -top-11 bg-gray-200 border border-gray-200 p-2 rounded-tr-3xl z-1 w-54">
        <MobileView.block_mobile_view block_id={@id} />
        <DarkMod.block_dark_mod block_id={@id} />
        <Settings.block_settings block_id={@id} selected_setting={@selected_setting} class={@class} />
        <Tag.block_tag block_id={@id} submit={@submit} />
        <div :if={@tag}><strong>Tag: </strong><%= @tag %></div>
        <AddSeparator.block_add_separator block_id={@id} />
        <Delete.delete_block block_id={@id} />
        <.live_component module={PureParent} id={"clear-#{@id}"} block_id={@id} />
        <ShowMore.block_more block_id={@id} />
      </div>

      <div
        id={"#{@id}"}
        class={Enum.join(@class, " ")}
        data-type="layout"
        data-parent-type="dragLocation"
        data-id={@id}
      >
        <Section.section
          :for={
            %{id: key, data: data} <- Enum.map(@order, fn key -> %{id: key, data: @children[key]} end)
          }
          id={key}
          children={data["children"]}
          selected_block={@selected_block}
          parent_id={@id}
          submit={@submit}
          tag={data["tag"]}
          order={data["order"]}
          class={data["class"]}
          selected_setting={@selected_setting}
        />
      </div>
    </div>
    """
  end
end
