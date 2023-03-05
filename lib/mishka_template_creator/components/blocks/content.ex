defmodule MishkaTemplateCreator.Components.Blocks.Content do
  use Phoenix.Component
  alias MishkaTemplateCreator.Components.Elements.Layout

  attr :elemens, :list, required: true
  attr :selected_block, :string, required: true
  attr :selected_setting, :map, required: true
  attr :submit, :string, required: true

  @spec content(map) :: Phoenix.LiveView.Rendered.t()
  def content(assigns) do
    ~H"""
    <div
      id="dragLocation"
      data-type="dragLocation"
      class="flex flex-col items-stretch justify-start pr-9 pl-0 pt-10 pb-96 mb-96 w-full space-y-16 lg:overflow-y-scroll lg:h-screen lg:min-h-screen mx-5 lg:pr-0"
    >
      <div
        :if={@elemens == []}
        id="previewHelper"
        class="flex flex-col justify-center items-center w-full border border-dashed border-gray-300 h-80 text-center object-center font-bold text-xl hover:border-blue-500 hover:duration-1000 hover:rounded-md rounded-sm duration-300 hover:text-blue-600 space-y-10"
      >
        <div>
          <Heroicons.arrow_down_tray class="w-32 h-32 stroke-current" />
        </div>
        <div>Drag And Drop a section here</div>
      </div>

      <Layout.layout
        :for={%{index: _index, type: _type, id: id, children: children} = el <- @elemens}
        id={id}
        children={children}
        selected_block={@selected_block}
        selected_setting={@selected_setting}
        submit={@submit}
        tag={Map.get(el, :tag)}
      />
    </div>
    """
  end
end
