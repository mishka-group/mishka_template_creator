defmodule MishkaTemplateCreatorWeb.MishkaCoreComponent do
  use Phoenix.Component
  import Phoenix.HTML.Form
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Data.TailwindSetting
  alias MishkaTemplateCreator.Components.Layout.{Content, Aside, History}
  alias Phoenix.LiveView.JS
  alias MishkaTemplateCreator.Data.Elements

  @elements Elements.elements(:all, :id)

  attr(:elements, :map, required: true)
  attr(:selected_block, :string, required: true)
  attr(:selected_setting, :map, required: false, default: nil)
  attr(:submit, :string, required: true)
  attr(:selected_form, :string, required: false, default: nil)

  @spec dashboard(map) :: Phoenix.LiveView.Rendered.t()
  def dashboard(assigns) do
    ~H"""
    <div class="main-body">
      <div id="mishka_top_nav" class="top-nav">
        <.live_component module={History} id="template-history" elements={@elements} />
        <div>Main Section</div>
        <div class="flex flex-row gap-2">
          <Heroicons.trash class="w-7 h-auto cursor-pointer" />
          <Heroicons.inbox_arrow_down class="w-7 h-auto cursor-pointer" />
          <Heroicons.computer_desktop class="w-7 h-auto cursor-pointer" />
          <Heroicons.square_3_stack_3d
            class="w-7 h-auto text-gray-800 cursor-pointer"
            id="blocks_stack"
            phx-click={
              JS.show(to: "#aside")
              |> JS.add_class("text-gray-800")
            }
          />
        </div>
      </div>
      <div
        id="mishka_content"
        data-id="mishka_content"
        class="flex flex-col-reverse mx-auto justify-between items-stretch w-full rounded-t-md lg:flex-row"
        phx-hook="dragAndDropLocation"
      >
        <Content.content
          elements={@elements}
          selected_block={@selected_block}
          submit={@submit}
          selected_setting={@selected_setting}
        />
        <Aside.aside selected_form={@selected_form} elements={@elements} submit={@submit} />
      </div>
    </div>
    """
  end

  # This is overwriting for modal, we add some `push_event` to it when it is closed or opened
  attr(:id, :string, required: true)
  attr(:show, :boolean, default: false)
  attr(:on_cancel, JS, default: %JS{})

  slot(:inner_block, required: true)

  @spec push_modal(map) :: Phoenix.LiveView.Rendered.t()
  def push_modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-reset={reset_push_modal(@id)}
      class="unsortable relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="fixed inset-0 bg-zinc-50/90 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-mounted={@show && show_modal(@id)}
              phx-window-keydown={JS.exec("data-reset", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-reset", to: "##{@id}")}
              class="hidden relative rounded-2xl bg-white px-5 py-5 shadow-lg shadow-zinc-700/10 ring-1 ring-zinc-700/10 transition z-50"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-reset", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label="close"
                >
                  <Heroicons.x_mark solid class="h-5 w-5 stroke-current" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                <%= render_slot(@inner_block) %>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr(:for, :any, required: true, doc: "the datastructure for the form")
  attr(:as, :any, default: nil, doc: "the server side parameter to collect all input under")
  attr(:class, :string, default: "space-y-8 bg-white mt-10")

  attr(:rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target),
    doc: "the arbitrary HTML attributes to apply to the form tag"
  )

  slot(:inner_block, required: true)
  slot(:actions, doc: "the slot for form actions, such as a submit button")

  def custom_simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest} class="w-full">
      <div class={@class}>
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  # This is overwriting for simple form
  attr(:for, :any, required: true, doc: "the datastructure for the form")
  attr(:as, :any, default: nil, doc: "the server side parameter to collect all input under")

  attr(:rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target),
    doc: "the arbitrary HTML attributes to apply to the form tag"
  )

  slot(:inner_block, required: true)
  slot(:actions, doc: "the slot for form actions, such as a submit button")

  def form_block(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  attr(:form, :any, required: true)
  attr(:options, :map, required: true)
  attr(:selected, :list, required: false, default: nil)
  attr(:title, :string, required: false, default: nil)
  attr(:form_id, :atom, required: false, default: nil)

  attr(:class, :string,
    required: false,
    default: "border !border-gray-300 rounded-md w-full space-y-2"
  )

  @spec multiple_select(map) :: Phoenix.LiveView.Rendered.t()
  def multiple_select(assigns) do
    ~H"""
    <h3 :if={@title} class="font-bold"><%= @title %>:</h3>
    <%= multiple_select(
      @form,
      @form_id || String.to_atom(@options.form_id),
      @options.form_configs,
      class: @class,
      selected: @selected
    ) %>
    """
  end

  attr(:form, :any, required: true)
  attr(:options, :map, required: true)
  attr(:selected, :any, required: false, default: nil)
  attr(:title, :string, required: false, default: nil)
  attr(:form_id, :atom, required: false, default: nil)

  attr(:class, :string,
    required: false,
    default: "border !border-gray-300 rounded-md w-full mx-0 my-0"
  )

  @spec select(map) :: Phoenix.LiveView.Rendered.t()
  def select(assigns) do
    ~H"""
    <h3 :if={@title} class="font-bold"><%= @title %>:</h3>
    <%= select(
      @form,
      @form_id || String.to_atom(@options.form_id),
      @options.form_configs,
      class: @class,
      selected: @selected,
      prompt: "Choose your config"
    ) %>
    """
  end

  @spec create_and_reevaluate_element(map(), map) :: nil | tuple()
  def create_and_reevaluate_element(elements, params) do
    params
    |> Map.delete("index")
    |> create_element()
    |> case do
      nil -> nil
      data -> elements_reevaluation(data, elements, params["parent_type"], params["index"])
    end
  rescue
    _ -> nil
  end

  # %{"type"=> type, "index" => index, "parent" => parent, "parent_id" => parent_id}
  @spec create_element(map()) :: nil | map
  def create_element(params) do
    id = Ecto.UUID.generate()
    blocks = Enum.filter(Elements.elements(:all, :id), &(&1 not in ["section", "layout"]))
    parent_type = String.split(params["parent_type"], ",")

    init_map = %{
      "#{id}" =>
        %{
          "children" => %{},
          "order" => []
        }
        |> Map.merge(TailwindSetting.default_element(params["type"]))
        |> Map.merge(params)
    }

    cond do
      params["type"] == "layout" and "dragLocation" in parent_type ->
        init_map

      params["type"] == "section" and "layout" in parent_type ->
        init_map

      params["type"] in blocks and "section" in parent_type ->
        init_map

      true ->
        nil
    end
  end

  @spec elements_reevaluation(map(), map(), String.t(), integer()) :: tuple()
  def elements_reevaluation(new_element, elements, "dragLocation" = type, index) do
    [id | _t] = Map.keys(new_element)

    new_elements =
      update_in(elements, ["children"], fn selected_element ->
        Map.merge(selected_element, new_element)
      end)
      |> change_order(id, index, nil, type)

    {new_elements, id}
  end

  def elements_reevaluation(new_element, elements, "layout,section" = type, index) do
    [id | _t] = Map.keys(new_element)
    parent_id = new_element[id]["parent_id"]

    if {new_element[id]["parent"], new_element[id]["type"]} == {"section", "section"} do
      # TODO: we should support section inside section
      nil
    else
      new_elements =
        update_in(
          elements,
          ["children", parent_id, "children"],
          fn selected_element -> Map.merge(selected_element, new_element) end
        )
        |> change_order(id, index, parent_id, type)

      {new_elements, id}
    end
  end

  def elements_reevaluation(new_element, elements, "section" = type, index) do
    [id | _t] = Map.keys(new_element)
    parent_id = new_element[id]["parent_id"]

    {layout_id, _layout_map} = find_element_grandparents(elements, section_id: parent_id)

    new_elements =
      update_in(
        elements,
        ["children", layout_id, "children", parent_id, "children"],
        fn selected_element -> Map.merge(selected_element, new_element) end
      )
      |> change_order(id, index, parent_id, type, layout_id)

    {new_elements, id}
  end

  def delete_element(elements, %{"id" => id, "type" => "layout"}) do
    {_, elements} = pop_in(elements, ["children", id])

    Map.merge(elements, %{
      "order" => delete_order_list_item(elements["order"], id)
    })
  end

  def delete_element(elements, %{"id" => id, "parent_id" => parent_id, "type" => "section"}) do
    {_, elements} = pop_in(elements, ["children", parent_id, "children", id])

    update_in(
      elements,
      ["children", parent_id],
      fn selected_element ->
        Map.merge(selected_element, %{
          "order" => delete_order_list_item(selected_element["order"], id)
        })
      end
    )
  end

  def delete_element(elements, %{"id" => id, "parent_id" => parent_id, "type" => type})
      when type in @elements do
    {layout_id, _layout_map} = find_element_grandparents(elements, section_id: parent_id)

    {_, elements} =
      pop_in(elements, ["children", layout_id, "children", parent_id, "children", id])

    update_in(
      elements,
      ["children", layout_id, "children", parent_id],
      fn selected_element ->
        Map.merge(selected_element, %{
          "order" => delete_order_list_item(selected_element["order"], id)
        })
      end
    )
  end

  def add_tag(elements, %{"id" => id, "parent_id" => _parent_id, "tag" => tag, "type" => "layout"}) do
    update_in(elements, ["children", id], fn selected_element ->
      Map.merge(selected_element, %{"tag" => tag})
    end)
  end

  def add_tag(elements, %{"id" => id, "parent_id" => parent_id, "tag" => tag, "type" => "section"}) do
    update_in(elements, ["children", parent_id, "children", id], fn selected_element ->
      Map.merge(selected_element, %{"tag" => tag})
    end)
  end

  def add_tag(elements, %{
        "id" => id,
        "parent_id" => parent_id,
        "layout_id" => layout_id,
        "tag" => tag,
        "type" => type
      })
      when type in @elements do
    update_in(
      elements,
      ["children", layout_id, "children", parent_id, "children", id],
      fn selected_element ->
        Map.merge(selected_element, %{"tag" => tag})
      end
    )
  end

  def add_class(elements, id, parent_id, classes, type, action \\ :normal)

  def add_class(elements, id, _parent_id, classes, "layout", :string_classes) do
    update_in(elements, ["children", id], fn selected_element ->
      Map.merge(selected_element, %{"class" => String.split(classes, " ")})
    end)
  end

  def add_class(elements, id, parent_id, classes, "section", :string_classes) do
    update_in(elements, ["children", parent_id, "children", id], fn selected_element ->
      Map.merge(selected_element, %{"class" => String.split(classes, " ")})
    end)
  end

  def add_class(elements, id, parent_id, classes, type, :string_classes) when type in @elements do
    {layout_id, _layout_map} = find_element_grandparents(elements, section_id: parent_id)

    update_in(
      elements,
      ["children", layout_id, "children", parent_id, "children", id],
      fn selected_element ->
        Map.merge(selected_element, %{"class" => String.split(classes, " ")})
      end
    )
  end

  def add_class(elements, id, _parent_id, class, "layout", :normal) do
    update_in(elements, ["children", id], fn selected_element ->
      Map.merge(selected_element, %{"class" => selected_element["class"] ++ [class]})
    end)
  end

  def add_class(elements, id, parent_id, class, "section", :normal) do
    update_in(elements, ["children", parent_id, "children", id], fn selected_element ->
      Map.merge(selected_element, %{"class" => selected_element["class"] ++ [class]})
    end)
  end

  def add_class(elements, id, parent_id, class, type, :normal) when type in @elements do
    {layout_id, _layout_map} = find_element_grandparents(elements, section_id: parent_id)

    update_in(
      elements,
      ["children", layout_id, "children", parent_id, "children", id],
      fn selected_element ->
        Map.merge(selected_element, %{"class" => selected_element["class"] ++ [class]})
      end
    )
  end

  def delete_class(elements, id, _parent_id, class, "layout") do
    update_in(elements, ["children", id], fn selected_element ->
      Map.merge(selected_element, %{
        "class" => Enum.reject(selected_element["class"], &(&1 == class))
      })
    end)
  end

  def delete_class(elements, id, parent_id, class, "section") do
    update_in(elements, ["children", parent_id, "children", id], fn selected_element ->
      Map.merge(selected_element, %{
        "class" => Enum.reject(selected_element["class"], &(&1 == class))
      })
    end)
  end

  def delete_class(elements, id, parent_id, class, type) when type in @elements do
    {layout_id, _layout_map} = find_element_grandparents(elements, section_id: parent_id)

    update_in(
      elements,
      ["children", layout_id, "children", parent_id, "children", id],
      fn selected_element ->
        Map.merge(selected_element, %{
          "class" => Enum.reject(selected_element["class"], &(&1 == class))
        })
      end
    )
  end

  def add_param(elements, id, _parent_id, map_wanted, "layout") do
    update_in(elements, ["children", id], fn selected_element ->
      Map.merge(selected_element, map_wanted)
    end)
  end

  def add_param(elements, id, parent_id, map_wanted, "section") do
    update_in(elements, ["children", parent_id, "children", id], fn selected_element ->
      Map.merge(selected_element, map_wanted)
    end)
  end

  def add_param(elements, id, parent_id, map_wanted, type) when type in @elements do
    {layout_id, _layout_map} = find_element_grandparents(elements, section_id: parent_id)

    update_in(
      elements,
      ["children", layout_id, "children", parent_id, "children", id],
      fn selected_element ->
        Map.merge(selected_element, map_wanted)
      end
    )
  end

  def delete_param(elements, %{"key" => key, "id" => id, "type" => "layout"}) do
    {_, elements} = pop_in(elements, ["children", id, key])

    elements
  end

  def delete_param(elements, %{
        "key" => key,
        "id" => id,
        "parent_id" => parent_id,
        "type" => "section"
      }) do
    {_, elements} = pop_in(elements, ["children", parent_id, "children", id, key])

    elements
  end

  def delete_param(elements, %{"key" => key, "id" => id, "parent_id" => parent_id, "type" => type})
      when type in @elements do
    {layout_id, _layout_map} = find_element_grandparents(elements, section_id: parent_id)

    {_, elements} =
      pop_in(elements, ["children", layout_id, "children", parent_id, "children", id, key])

    elements
  end

  def find_element(elements, id, _parent_id, _layout_id, "layout"),
    do: get_in(elements, ["children", id])

  def find_element(elements, id, parent_id, _layout_id, "section"),
    do: get_in(elements, ["children", parent_id, "children", id])

  def find_element(elements, id, parent_id, layout_id, type) when type in @elements do
    get_in(elements, ["children", layout_id, "children", parent_id, "children", id])
  end

  def change_order(elements, id, new_index, _parent_id, "dragLocation") do
    elements
    |> Map.merge(%{
      "order" => update_order_list(elements["order"], id, new_index)
    })
  end

  def change_order(elements, id, new_index, parent_id, "layout,section") do
    elements
    |> update_in(
      ["children", parent_id],
      fn selected_element ->
        selected_element
        |> Map.merge(%{
          "order" => update_order_list(selected_element["order"], id, new_index)
        })
      end
    )
  end

  def change_order(elements, id, new_index, parent_id, "section", layout_id \\ nil) do
    layout_id =
      if is_nil(layout_id) do
        {layout_id, _layout_map} = find_element_grandparents(elements, section_id: parent_id)
        layout_id
      else
        layout_id
      end

    elements
    |> update_in(
      ["children", layout_id, "children", parent_id],
      fn selected_element ->
        selected_element
        |> Map.merge(%{
          "order" => update_order_list(selected_element["order"], id, new_index)
        })
      end
    )
  end

  def sorted_list_by_order(order, children) do
    Enum.map(order, fn key -> %{id: key, data: children[key]} end)
  end

  defp update_order_list(list, id, new_index) do
    list
    |> Enum.reject(&(&1 == id))
    |> List.insert_at(new_index, id)
  end

  defp delete_order_list_item(list, id), do: Enum.reject(list, &(&1 == id))

  @spec string_map_to_atom(map) :: map
  def string_map_to_atom(map) do
    map
    |> Map.new(fn {k, v} ->
      {String.to_existing_atom(k), v}
    end)
  end

  @spec atom_map_to_string(map) :: map
  def atom_map_to_string(map) do
    for {key, val} <- map, into: %{} do
      {to_string(key), to_string(val)}
    end
  end

  defp reset_push_modal(id) do
    JS.remove_class("hidden", to: ".setting_modal")
    |> JS.remove_class("hidden", to: ".setting_modal_custom_class_start")
    |> JS.add_class("hidden", to: ".setting_modal_custom_class_back")
    |> JS.add_class("hidden", to: ".custom_class-form")
    |> hide_modal(id)
    |> JS.push("reset")
  end

  # TODO: it should support Layout --> Section --> Section --> Element
  defp find_element_grandparents(elements, section_id: section_id) do
    Enum.find(elements["children"], fn {_key, map} ->
      Map.has_key?(map["children"], section_id)
    end)
  end
end
