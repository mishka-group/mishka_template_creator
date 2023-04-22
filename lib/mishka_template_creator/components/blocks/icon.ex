defmodule MishkaTemplateCreator.Components.Blocks.Icon do
  use Phoenix.Component
  alias MishkaTemplateCreator.Data.TailwindSetting

  attr(:module, :string, required: true)
  attr(:class, :string, required: false, default: "w-6 h-6 mx-auto stroke-current")

  def dynamic(assigns) do
    ~H"""
    <%= Phoenix.LiveView.TagEngine.component(
      Code.eval_string("&(#{@module}/1)") |> elem(0),
      [class: @class],
      {__ENV__.module, __ENV__.function, __ENV__.file, __ENV__.line}
    ) %>
    """
  end

  attr(:myself, :integer, required: true)
  attr(:selected, :string, required: false, default: nil)
  attr(:block_id, :string, required: false, default: nil)

  attr(:class, :string,
    required: false,
    default: "w-4 h-4 mx-auto stroke-current text-black cursor-pointer"
  )

  def select(assigns) do
    assigns = assign(assigns, icons: TailwindSetting.hero_icons())

    ~H"""
    <div class="flex flex-wrap w-full gap-1 border border-gray-300 p-3 rounded-md mb-3 justify-start">
      <span
        :for={icon <- @icons}
        phx-click="select_icon"
        phx-value-name={icon}
        phx-value-block-id={@block_id}
        phx-target={@myself}
      >
        <.dynamic
          module={"Heroicons.#{icon}"}
          class={@class <> "#{if @selected == icon, do: " !text-red-600", else: ""}"}
        />
      </span>
    </div>
    """
  end
end
