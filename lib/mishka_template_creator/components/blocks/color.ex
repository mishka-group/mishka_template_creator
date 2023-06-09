defmodule MishkaTemplateCreator.Components.Blocks.Color do
  use Phoenix.Component
  alias MishkaTemplateCreator.Data.TailwindSetting

  attr(:myself, :integer, required: true)
  attr(:classes, :list, required: true)
  attr(:title, :string, required: false, default: "Color:")
  attr(:type, :string, required: false, default: "text")
  attr(:event_name, :string, required: false, default: "select_color")
  attr(:id, :string, required: false, default: nil)
  attr(:parent_id, :string, required: false, default: nil)

  attr(:class, :string,
    required: false,
    default: "flex flex-col w-full justify-between items-stretch pt-3 pb-5"
  )

  def select(assigns) do
    assigns =
      assign(assigns,
        colors:
          TailwindSetting.get_form_options("typography", "text-color", nil, nil).form_configs
      )

    ~H"""
    <div class={@class}>
      <span class="w-full"><%= @title %></span>
      <div class="flex flex-wrap w-full mt-4">
        <div
          :for={item <- @colors}
          :if={item not in ["text-inherit", "text-current", "text-transparent"]}
          class={"bg-#{String.replace(item, "text-", "")} w-4 h-4 cursor-pointer"}
          phx-click={@event_name}
          phx-value-color={String.replace(item, "text", @type)}
          phx-value-id={@id}
          phx-value-parent-id={@parent_id}
          phx-target={@myself}
        >
          <Heroicons.x_mark
            :if={String.replace(item, "text", @type) in @classes}
            class={if(item in TailwindSetting.different_selected_color(), do: "text-white")}
          />
        </div>
      </div>
    </div>
    """
  end
end
