defmodule MishkaTemplateCreator.Components.Blocks.Settings do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  import MishkaTemplateCreatorWeb.CoreComponents
  import MishkaTemplateCreatorWeb.MishkaCoreComponent
  alias MishkaTemplateCreator.{Components.Blocks.ElementMenu, Data.TailwindSetting}

  attr :block_id, :string, required: true
  attr :type, :string, required: false, default: "layout"
  attr :selected_setting, :map, required: false, default: nil
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_settings(map) :: Phoenix.LiveView.Rendered.t()
  def block_settings(%{type: _type} = assigns) do
    assigns = assign(assigns, :tailwind_settings, TailwindSetting.call())

    ~H"""
    <Heroicons.wrench_screwdriver
      class={@custom_class}
      phx-click={show_modal("#{@type}-settings-#{@block_id}")}
    />
    <.push_modal id={"#{@type}-settings-#{@block_id}"}>
      <%= if is_nil(@selected_setting) do %>
        <p class="text-center font-bold mb-4 text-lg">Please select the section you want to edit</p>
        <div class="grid grid-cols-2 gap-3 text-gray-500 mt-8 mb-10 md:grid-cols-4 lg:grid-cols-5">
          <ElementMenu.block_menu
            :for={{id, title, module, _settings} <- @tailwind_settings}
            id={id}
            title={title}
            phx-click="selected_setting"
            phx-value-id={id}
            phx-value-child={nil}
          >
            <%= Phoenix.LiveView.HTMLEngine.component(
              Code.eval_string("&#{module}/1") |> elem(0),
              [class: "w-6 h-6 mx-auto stroke-current"],
              {__ENV__.module, __ENV__.function, __ENV__.file, __ENV__.line}
            ) %>
          </ElementMenu.block_menu>
        </div>
        <p
          class="text-center text-sm text-blue-400"
          phx-click="add_custom_class"
          phx-value-id={@block_id}
          phx-value-type={@type}
        >
          <span>OR put your custom classes</span>
        </p>
      <% else %>
        <div class="flex flex-col mx-auto w-full">
          <p class="text-center font-bold text-2xl text-gray-500 mb-6">
            You can change the default setting of
            <code class="bg-pink-400 text-white font-normal p-1 rounded-md text-sm text-center">
              <%= TailwindSetting.get_title(@tailwind_settings, @selected_setting) %>
            </code>
          </p>

          <div class="flex flex-row gap-2 text-center mx-auto mb-3">
            <.button
              phx-click="reset_settings"
              class="w-24 !bg-white border border-gray-300 shadow-sm !text-black hover:bg-gray-400 hover:text-gray-400"
            >
              <div class="flex flex-row text-center gap-2">
                <span>Back</span>
                <Heroicons.arrow_long_left class="w-6 h-6 stroke-current" />
              </div>
            </.button>

            <.button
              phx-click="reset_settings"
              class="!bg-white border border-gray-300 shadow-sm !text-black hover:bg-gray-400 hover:text-gray-400"
            >
              <div class="flex flex-row text-center gap-2">
                <span>Reset to default</span>
                <Heroicons.arrow_path class="w-6 h-6 stroke-current" />
              </div>
            </.button>
          </div>
          <hr />

          <.create_form id={@selected_setting["id"]} child={@selected_setting["child"]} />
        </div>
      <% end %>
    </.push_modal>
    """
  end

  attr :id, :string, required: true
  attr :child, :string, required: false, default: nil

  defp create_form(%{id: id, child: child} = assigns) do
    assigns = assign(assigns, :selected_setting, TailwindSetting.get_form_options(id, child))

    ~H"""
    <div class="flex flex-row w-full max-h-80 overflow-y-scroll">
      <div class="flex flex-col mt-3 gap-2 w-1/3 border-r h-fit pr-3 self-stretch">
        <.button
          :for={
            {field_id, field_title, _field_description, _field_configs, _field_allowed_types} <-
              @selected_setting.section
          }
          id={field_id}
          phx-click="selected_setting"
          phx-value-id={@id}
          phx-value-child={field_id}
          class="!bg-white border-b border-gray-300 shadow-sm text-gray-600 hover:bg-gray-400 hover:text-gray-400 w-full !rounded-none"
        >
          <div class={"#{if field_id == @selected_setting.form_id, do: "font-bold", else: "font-normal"}"}>
            <%= field_title %>
          </div>
        </.button>
      </div>
      <div class="flex flex-col w-2/3 p-3 self-stretch">
        <code class="text-black font-bold p-1 rounded-md text-lg text-center mb-3">
          <%= @selected_setting.form_id %>
        </code>
        <h2 class="mb-3 text-sm text-gray-500 leading-6">
          You can apply the following settings on this section. If you don't need to change the settings, you can skip this section.
        </h2>
        <.form_block :let={f} for={%{}} as={String.to_atom(@id)} phx-change="save_config">
          <.aggregate_forms_type_in_favor_of_types f={f} options={@selected_setting} />
        </.form_block>
      </div>
    </div>
    """
  end

  attr :f, :any, required: true
  attr :options, :map, required: true
  attr :selected, :any, required: false, default: nil
  attr :sizes, :list, required: false, default: [:sm, :md, :lg, :xl, :"2xl"]

  @spec aggregate_forms_type_in_favor_of_types(map) :: Phoenix.LiveView.Rendered.t()
  def aggregate_forms_type_in_favor_of_types(assigns) do
    ~H"""
    <.multiple_select
      :if={:multi_select in @options.types}
      form={@f}
      options={@options}
      selected={@selected}
    />
    <.select
      :if={:multi_select not in @options.types}
      form={@f}
      options={@options}
      selected={@selected}
    />

    <div class="flex flex-col space-y-3">
      <h2 :if={:media_queries in @options.types} class="mt-3 text-lg font-semibold">
        You can set it for different sizes:
      </h2>
      <h2 class="mb-3 text-sm text-gray-500 leading-6">
        To adjust in different sizes, consider the first mobile step or the smallest size and go to larger sizes
      </h2>
      <hr />
      <.multiple_select
        :for={size <- @sizes}
        :if={:multi_select in @options.types and :media_queries in @options.types}
        form={@f}
        options={@options}
        form_id={size}
        title={size}
      />
      <.select
        :for={size <- @sizes}
        :if={:multi_select not in @options.types and :media_queries in @options.types}
        form={@f}
        options={@options}
        form_id={size}
        title={size}
      />
    </div>
    """
  end

  def aggregate_form_data_in_favor_of_tailwind(_form_data) do
  end
end
