defmodule MishkaTemplateCreator.Components.Blocks.Aside do
  use Phoenix.Component
  alias MishkaTemplateCreator.Components.Blocks.ElementMenu
  alias Phoenix.LiveView.JS

  attr(:selected_form, :string, required: false, default: nil)

  @spec aside(map) :: Phoenix.LiveView.Rendered.t()
  def aside(%{selected_form: selected_form} = assigns) do
    atom_created =
      if !is_nil(selected_form),
        do:
          Module.safe_concat(
            "Elixir.MishkaTemplateCreator.Components.Elements",
            String.capitalize(selected_form.element_type)
          ),
        else: nil

    assigns = assign(assigns, block_module: atom_created)

    ~H"""
    <div
      id="aside"
      class="flex flex-col w-[95%] h-[300px] mx-auto bg-white border-t-0 border-l border-r border-b border-[rgb(229,229,229)] rounded-t-md md:pb-20 overflow-y-scroll overflow-x-hidden lg:w-5/12 lg:h-screen lg:mx-0 xl:w-4/12"
    >
      <div
        :if={is_nil(@selected_form)}
        class="flex flex-row justify-between items-stretch p-4 border-b border-[rgb(229,229,229)]"
      >
        <div class="font-bold flex flex-row justify-start items-center space-x-1 text-2xl">
          <span>
            <Heroicons.code_bracket_square class="w-7 h-7 mx-auto stroke-current" />
          </span>
          <span>List of Blocks</span>
        </div>
        <div>
          <Heroicons.x_mark
            class="w-6 h-6 mx-auto stroke-current"
            phx-click={
              JS.hide(to: "#aside")
              |> JS.remove_class("text-gray-800", to: "#blocks_stack")
            }
          />
        </div>
      </div>
      <div
        :if={is_nil(@selected_form)}
        id="mishka_search"
        class="w-full border-b border-[rgb(229,229,229)]"
      >
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

      <div id="aside-content">
        <ElementMenu.aside_menu :if={is_nil(@selected_form)} />

        <.live_component
          :if={!is_nil(@selected_form)}
          module={@block_module}
          id={@selected_form.element_id <> "-form"}
          selected_form={@selected_form}
          render_type="form"
        />
      </div>
    </div>
    """
  end

  attr(:id, :string, required: true)
  slot(:inner_block, required: true)

  @spec aside_settings(map) :: Phoenix.LiveView.Rendered.t()
  def aside_settings(assigns) do
    ~H"""
    <div id={"#{@id}"} class="flex flex-col w-full pt-5">
      <div class="flex flex-row justify-between border-b pb-5 w-full">
        <h3 class="flex flex-row px-5 text-2xl font-bold gap-2 items-center">
          <span class="mt-1 border border-gray-300 rounded-md p-1">
            <Heroicons.cog_8_tooth class="w-5 h-5" />
          </span>
          <span class="mt-1">Settings:</span>
        </h3>

        <div
          class="px-5 flex flex-row items-center text-2xl gap-2 cursor-pointer hover:text-gray-500 hover:duration-150 duration-150"
          phx-click="back_to_blocks"
        >
          <Heroicons.arrow_long_left class="w-6 h-6 mt-2" />
          <span class="mt-1">Back</span>
        </div>
      </div>

      <div class="flex flex-col w-full p-5 justify-start items-start gap-5">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
