defmodule MishkaTemplateCreator.Components.Blocks.Settings do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  import MishkaTemplateCreatorWeb.CoreComponents
  import MishkaTemplateCreatorWeb.MishkaCoreComponent

  alias MishkaTemplateCreator.{
    Components.Blocks.ElementMenu,
    Components.Blocks.CustomClass,
    Data.TailwindSetting,
    Components.ConfigSelector
  }

  attr :block_id, :string, required: true
  attr :class, :string, required: false, default: nil
  attr :parent_id, :string, required: false, default: nil
  attr :type, :string, required: false, default: "layout"
  attr :selected_setting, :map, required: false, default: nil
  attr :icon_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_settings(map) :: Phoenix.LiveView.Rendered.t()
  def block_settings(%{type: _type, block_id: _block_id} = assigns) do
    assigns = assign(assigns, :tailwind_settings, TailwindSetting.call())

    ~H"""
    <Heroicons.wrench_screwdriver
      class={@icon_class}
      phx-click={show_modal("#{@type}-settings-#{@block_id}")}
    />
    <.push_modal id={"#{@type}-settings-#{@block_id}"}>
      <%= if is_nil(@selected_setting) do %>
        <div class="setting_modal">
          <p class="text-center font-bold mb-4 text-lg">Please select the section you want to edit</p>
          <div class="grid grid-cols-2 gap-3 text-gray-500 mt-8 mb-5 md:grid-cols-4 lg:grid-cols-5">
            <ElementMenu.block_menu
              :for={{id, title, module, _settings} <- @tailwind_settings}
              id={id}
              title={title}
              phx-click="set"
              phx-value-id={id}
              phx-value-child={nil}
              phx-value-type="setting"
            >
              <%= Phoenix.LiveView.TagEngine.component(
                Code.eval_string("&#{module}/1") |> elem(0),
                [class: "w-6 h-6 mx-auto stroke-current"],
                {__ENV__.module, __ENV__.function, __ENV__.file, __ENV__.line}
              ) %>
            </ElementMenu.block_menu>
          </div>
        </div>

        <p class="text-center text-sm text-blue-400">
          <span
            class="setting_modal_custom_class_start select-none cursor-pointer"
            phx-click={
              JS.add_class("hidden", to: ".setting_modal")
              |> JS.add_class("hidden", to: ".setting_modal_custom_class_start")
              |> JS.remove_class("hidden", to: ".setting_modal_custom_class_back")
              |> JS.remove_class("hidden", to: ".custom_class-form")
            }
          >
            OR put your custom classes
          </span>
          <span
            class="setting_modal_custom_class_back select-none cursor-pointer hidden"
            phx-click={
              JS.remove_class("hidden", to: ".setting_modal")
              |> JS.remove_class("hidden", to: ".setting_modal_custom_class_start")
              |> JS.add_class("hidden", to: ".setting_modal_custom_class_back")
              |> JS.add_class("hidden", to: ".custom_class-form")
            }
          >
            Back to settings
          </span>
        </p>
        <div class="custom_class-form hidden">
          <.live_component
            module={CustomClass}
            id={"custom_class-#{@type}-#{@block_id}"}
            parent_id={@parent_id}
            block_id={@block_id}
            type={@type}
            class={@class}
          />
        </div>
      <% else %>
        <div class="flex flex-col mx-auto w-full">
          <p class="text-center font-bold text-2xl text-gray-500 mb-6">
            You can change the default setting of
            <code class="bg-pink-400 text-white font-normal p-1 rounded-md text-sm text-center">
              <%= TailwindSetting.get_title(@tailwind_settings, @selected_setting) %>
            </code>
          </p>

          <div class="flex flex-row gap-2 text-center mx-auto mb-3 justify-center items-center">
            <.button
              phx-click="reset"
              phx-value-type="setting"
              class="w-24 !bg-white border border-gray-300 shadow-sm !text-black hover:bg-gray-400 hover:text-gray-400"
            >
              <div class="flex flex-row text-center gap-2">
                <span>Back</span>
                <Heroicons.arrow_long_left class="w-6 h-6 stroke-current" />
              </div>
            </.button>

            <.button
              phx-click="reset"
              phx-value-type="setting"
              class="!bg-white border border-gray-300 shadow-sm !text-black hover:bg-gray-400 hover:text-gray-400"
            >
              <div class="flex flex-row text-center gap-2">
                <span>Reset to default</span>
                <Heroicons.arrow_path class="w-6 h-6 stroke-current" />
              </div>
            </.button>
          </div>
          <h2 class="mb-3 text-sm text-gray-500 leading-6 text-center">
            You can apply the following settings on this section. If you don't need to change the settings, you can skip this section.
          </h2>
          <hr />

          <.create_form
            id={@selected_setting["id"]}
            child={@selected_setting["child"]}
            type={@type}
            block_id={@block_id}
            class={@class}
            parent_id={@parent_id}
          />
        </div>
      <% end %>
    </.push_modal>
    """
  end

  attr :id, :string, required: true
  attr :type, :string, required: true
  attr :block_id, :string, required: true
  attr :child, :string, required: false, default: nil
  attr :parent_id, :string, required: false, default: nil
  attr :class, :string, required: false, default: nil

  defp create_form(%{id: id, child: child, type: type, block_id: block_id} = assigns) do
    assigns =
      assign(
        assigns,
        :selected_setting,
        TailwindSetting.get_form_options(id, child, type, block_id)
      )

    ~H"""
    <div class="max-h-[24rem] overflow-y-scroll">
      <div class="flex flex-row w-full">
        <div class="flex flex-col mt-3 gap-2 w-1/3 border-r pr-3 overflow-y-scroll max-h-80">
          <.button
            :for={{field_id, field_title} <- @selected_setting.section}
            id={"#{Ecto.UUID.generate}-#{field_id}"}
            phx-click="set"
            phx-value-id={@id}
            phx-value-child={field_id}
            phx-value-type="setting"
            class="!bg-white border-b border-gray-300 shadow-sm text-gray-600 hover:bg-gray-400 hover:text-gray-400 w-full !rounded-none"
          >
            <div class={"#{if field_id == @selected_setting.form_id, do: "font-bold", else: "font-normal"}"}>
              <%= field_title %>
            </div>
          </.button>
        </div>
        <div class="flex flex-col w-3/4 px-3 self-stretch">
          <code class="text-black font-bold p-1 rounded-md text-lg text-center mb-1">
            <%= @selected_setting.form_id %>
          </code>
          <.live_component
            module={ConfigSelector}
            id={"#{@type}-#{@block_id}-#{@id}-#{@child || List.first(@selected_setting.form_configs)}"}
            selected_setting={@selected_setting}
            class={@class}
            parent_id={@parent_id}
          />
        </div>
      </div>
    </div>
    """
  end

  def aggregate_form_data_in_favor_of_tailwind(_form_data) do
  end
end
