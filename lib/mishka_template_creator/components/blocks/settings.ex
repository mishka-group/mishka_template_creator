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
            phx-value-type={@type}
            phx-value-block-id={@block_id}
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
              class="w-24 !bg-white border border-gray-300 shadow-sm text-black hover:bg-gray-400 hover:text-gray-400"
            >
              <div class="flex flex-row text-center gap-2">
                <span>Back</span>
                <Heroicons.arrow_long_left class="w-6 h-6 stroke-current" />
              </div>
            </.button>

            <.button
              phx-click="reset_settings"
              class="!bg-white border border-gray-300 shadow-sm text-black hover:bg-gray-400 hover:text-gray-400"
            >
              <div class="flex flex-row text-center gap-2">
                <span>Reset to default</span>
                <Heroicons.arrow_path class="w-6 h-6 stroke-current" />
              </div>
            </.button>
          </div>
          <hr />

          <.create_form id={@selected_setting["id"]} />
        </div>
      <% end %>
    </.push_modal>
    """
  end

  attr :selected_setting, :map, required: true

  @spec get_form(map) :: Phoenix.LiveView.Rendered.t()
  def get_form(assigns) do
    ~H"""
    <.simple_form
      :let={f}
      for={%{}}
      as={:setting_form}
      phx-submit="save_setting"
      phx-change="validate_setting"
      class="z-40"
    >
      <.input field={f[:setting_form]} label="Tag Name" />
      <:actions>
        <.button class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 disabled:bg-gray-400 disabled:text-white disabled:outline-none">
          Save
        </.button>
      </:actions>
    </.simple_form>
    """
  end

  attr :id, :string, required: true

  defp create_form(%{id: id} = assigns) do
    assigns =
      assign(assigns, :selected_setting, Enum.find(TailwindSetting.call(), &(elem(&1, 0) == id)))

    ~H"""
    <div class="flex flex-row w-full max-h-80 overflow-y-scroll">
      <div class="flex flex-col mt-3 gap-2 w-1/3 border-r h-max pr-3">
        <.button
          :for={
            {field_id, field_title, _field_description, _field_configs, _field_allowed_types} = _el <-
              elem(@selected_setting, 3)
          }
          id={field_id}
          phx-click="select_config"
          phx-value-id={field_id}
          class="!bg-white border-b border-gray-300 shadow-sm text-gray-600 hover:bg-gray-400 hover:text-gray-400 w-full rounded-none"
        >
          <%= field_title %>
        </.button>
      </div>
      <div class="flex flex-col w-2/3 p-3">
        <.form_block :let={f} for={%{}} as={:config_form} phx-change="save_config">
          <.input field={f[:config_form]} label="Tag Name" />
        </.form_block>
      </div>
    </div>
    """
  end

  def aggregate_form_data_in_favor_of_tailwind(_form_data) do
  end
end
