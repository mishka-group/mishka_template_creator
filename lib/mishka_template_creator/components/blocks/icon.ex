defmodule MishkaTemplateCreator.Components.Blocks.Icon do
  use Phoenix.Component
  import Phoenix.HTML.Form
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias alias MishkaTemplateCreatorWeb.MishkaCoreComponent

  @svg_height [
    "h-1",
    "h-2",
    "h-3",
    "h-4",
    "h-5",
    "h-6",
    "h-7",
    "h-8",
    "h-9",
    "h-10",
    "h-11",
    "h-12",
    "h-14",
    "h-16",
    "h-20",
    "h-24",
    "h-28",
    "h-32",
    "h-36"
  ]

  @svg_width [
    "w-1",
    "w-2",
    "w-3",
    "w-4",
    "w-5",
    "w-6",
    "w-7",
    "w-8",
    "w-9",
    "w-10",
    "w-11",
    "w-12",
    "w-14",
    "w-16",
    "w-20",
    "w-24",
    "w-28",
    "w-32",
    "w-36"
  ]

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
  attr(:id, :string, required: false, default: nil)

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

  attr(:myself, :integer, required: true)
  attr(:classes, :list, required: true)
  attr(:event_name, :string, required: false, default: "font_style")
  attr(:title, :string, required: false, default: "Size")
  attr(:as, :atom, required: false, default: :tab_icon_style)
  attr(:id_input, :string, required: false, default: nil)

  attr(:class, :string,
    required: false,
    default: "w-full m-0 p-0 flex flex-col"
  )

  def select_size(assigns) do
    ~H"""
    <MishkaCoreComponent.custom_simple_form
      :let={f}
      for={%{}}
      as={@as}
      phx-change={@event_name}
      phx-target={@myself}
      class={@class}
    >
      <div class="flex flex-row w-full justify-between items-stretch pt-3 pb-5">
        <span class="w-3/5"><%= @title %>:</span>
        <div class="flex flex-row w-full gap-2 items-center">
          <span class="py-1 px-2 border border-gray-300 text-xs rounded-md">
            <%= find_index_svg_sizes(@classes).width %>
          </span>
          <span>
            W:
          </span>

          <%= range_input(f, :width,
            min: "0",
            max: "18",
            value: find_index_svg_sizes(@classes).width,
            class: "w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer",
            id: "font-style-width-#{Atom.to_string(@as)}-#{@id || ""}"
          ) %>

          <span class="py-1 px-2 border border-gray-300 text-xs rounded-md">
            <%= find_index_svg_sizes(@classes).height %>
          </span>
          <span>
            H:
          </span>

          <%= range_input(f, :height,
            min: "0",
            max: "18",
            value: find_index_svg_sizes(@classes).height,
            class: "w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer",
            id: "font-style-height-#{Atom.to_string(@as)}-#{@id || ""}"
          ) %>

          <.input
            :if={!is_nil(@id_input)}
            field={f[:id]}
            type="hidden"
            value={@id_input}
            id={"font-style-id-#{Atom.to_string(@as)}-#{@id_input}"}
          />
        </div>
      </div>
    </MishkaCoreComponent.custom_simple_form>
    """
  end

  def edit_icon_size(classes, [width, height]) do
    all_sizes = @svg_height ++ @svg_width

    Enum.reject(classes, &(&1 in all_sizes)) ++
      [convert_size(@svg_width, width), convert_size(@svg_height, height)]
  end

  defp convert_size(list, index), do: Enum.at(list, String.to_integer(index)) || Enum.at(list, 0)

  defp find_index_svg_sizes(classes) do
    %{
      width: find_revers_list(@svg_width, classes),
      height: find_revers_list(@svg_height, classes)
    }
  end

  defp find_revers_list(list, classes) do
    Enum.find(Enum.with_index(list), fn {item, _index} -> item in classes end)
    |> case do
      nil -> 0
      {_data, index} -> index
    end
  end
end
