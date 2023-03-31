defmodule MishkaTemplateCreator.Components.Blocks.Aside do
  use Phoenix.Component
  alias MishkaTemplateCreator.Components.Blocks.ElementMenu

  attr(:select_form, :string, required: false, default: nil)

  @spec aside(map) :: Phoenix.LiveView.Rendered.t()
  def aside(assigns) do
    ~H"""
    <div class="flex flex-col w-[95%] h-[300px] mx-auto bg-white border-t-0 border-l border-r border-b border-[rgb(229,229,229)] rounded-t-md md:pb-20 overflow-y-scroll overflow-x-hidden lg:w-5/12 lg:h-screen lg:mx-0 xl:w-4/12">
      <div :if={is_nil(@select_form)} class="flex flex-row justify-between items-stretch p-4 border-b border-[rgb(229,229,229)]">
        <div class="font-bold flex flex-row justify-start items-stretch space-x-1">
          <span>
            <Heroicons.code_bracket_square class="w-6 h-6 mx-auto stroke-current" />
          </span>
          <span>Title of Block</span>
        </div>
        <div>
          <Heroicons.x_mark class="w-6 h-6 mx-auto stroke-current" />
        </div>
      </div>
      <div :if={is_nil(@select_form)} id="mishka_search" class="w-full border-b border-[rgb(229,229,229)]">
        <div class="relative">
          <div class="flex absolute inset-y-0 left-0 items-center pl-3 pointer-events-none">
            <Heroicons.magnifying_glass class="w-6 h-6 mx-auto stroke-current" />
          </div>
          <input
            type="text"
            id="search_blocks"
            class="border-0 focus:ring-blue-300 focus:border-blue-300 block w-full pl-10 p-2.5"
            placeholder="Search Blocks"
          />
        </div>
      </div>

      <ElementMenu.aside_menu :if={is_nil(@select_form)} />
    </div>
    """
  end
end
