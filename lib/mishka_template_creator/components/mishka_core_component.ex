defmodule MishkaTemplateCreatorWeb.MishkaCoreComponent do
  use Phoenix.Component
  import Phoenix.HTML.Form

  alias MishkaTemplateCreator.Components.Blocks.{Content, Aside}
  alias Phoenix.LiveView.JS
  import MishkaTemplateCreatorWeb.CoreComponents

  @elements_type ["text", "tabs"]

  attr :elemens, :list, required: true
  attr :selected_block, :string, required: true
  attr :selected_setting, :map, required: false, default: nil
  attr :submit, :string, required: true

  @spec dashboard(map) :: Phoenix.LiveView.Rendered.t()
  def dashboard(assigns) do
    ~H"""
    <div class="main-body">
      <div id="mishka_top_nav" class="top-nav">
        <div>Back To/History</div>
        <div>Main Section</div>
        <div>Settings</div>
      </div>
      <div
        id="mishka_content"
        data-id="mishka_content"
        class="flex flex-col-reverse mx-auto justify-between items-stretch w-full rounded-t-md lg:flex-row"
        phx-hook="dragAndDropLocation"
      >
        <Content.content
          elemens={@elemens}
          selected_block={@selected_block}
          submit={@submit}
          selected_setting={@selected_setting}
        />
        <Aside.aside />
      </div>
    </div>
    """
  end

  # This is overwriting for modal, we add some `push_event` to it when it is closed or opened
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}

  slot :inner_block, required: true

  @spec push_modal(map) :: Phoenix.LiveView.Rendered.t()
  def push_modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      class="relative z-50 hidden"
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
              phx-window-keydown={hide_modal(@on_cancel, @id) |> JS.push("reset")}
              phx-key="escape"
              phx-click-away={hide_modal(@on_cancel, @id) |> JS.push("reset")}
              class="hidden relative rounded-2xl bg-white p-14 shadow-lg shadow-zinc-700/10 ring-1 ring-zinc-700/10 transition z-50"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={hide_modal(@on_cancel, @id) |> JS.push("reset")}
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

  # This is overwriting for simple form
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

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

  attr :form, :any, required: true
  attr :options, :map, required: true
  attr :selected, :list, required: false, default: nil
  attr :title, :string, required: false, default: nil
  attr :form_id, :atom, required: false, default: nil

  attr :class, :string,
    required: false,
    default: "border !border-gray-300 rounded-md w-full space-y-2"

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

  attr :form, :any, required: true
  attr :options, :map, required: true
  attr :selected, :any, required: false, default: nil
  attr :title, :string, required: false, default: nil
  attr :form_id, :atom, required: false, default: nil

  attr :class, :string,
    required: false,
    default: "border !border-gray-300 rounded-md w-full mx-0 my-0"

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

  def create_element(%{type: type, index: _index, parent: parent, parent_id: _parent_id} = params) do
    id = Ecto.UUID.generate()

    cond do
      type == "layout" and parent == "dragLocation" ->
        Map.merge(params, %{id: id, children: []})

      type == "section" and parent == "layout" ->
        Map.merge(params, %{id: id, children: []})

      type in @elements_type and parent == "section" ->
        Map.merge(params, %{id: id, children: []})

      true ->
        nil
    end
  end

  def elements_reevaluation(elements, new_element, "dragLocation") do
    List.insert_at(elements, new_element.index, new_element)
    |> sort_elements_list()
  end

  def elements_reevaluation(elements, new_element, "layout") do
    Enum.map(elements, fn el ->
      if el.id == new_element.parent_id do
        Map.merge(el, %{
          children:
            el.children
            |> List.insert_at(new_element.index, new_element)
            |> sort_elements_list()
        })
      else
        el
      end
    end)
  end

  def elements_reevaluation(elements, new_element, "section") do
    Enum.map(elements, fn %{type: "layout", children: children} = layout ->
      updated_children =
        Enum.map(children, fn data ->
          if data.type == "section" && data.id == new_element.parent_id do
            children = List.insert_at(data.children, new_element.index, new_element)
            %{data | children: sort_elements_list(children)}
          else
            data
          end
        end)

      %{layout | children: sort_elements_list(updated_children)}
    end)
  end

  def change_order(elements, current_index, new_index, _parent_id, "layout") do
    current_Element = Enum.at(elements, current_index)

    elements
    |> List.delete_at(current_index)
    |> List.insert_at(new_index, current_Element)
    |> sort_elements_list(false)
  end

  def change_order(elements, current_index, new_index, parent_id, "section") do
    Enum.map(elements, fn %{type: "layout", children: children} = layout ->
      if layout.id == parent_id do
        current_Element = Enum.at(children, current_index)

        sorted_list =
          children
          |> List.delete_at(current_index)
          |> List.insert_at(new_index, current_Element)
          |> sort_elements_list(false)

        %{layout | children: sorted_list}
      else
        layout
      end
    end)
  end

  def change_order(elements, current_index, new_index, parent_id, type)
      when type in @elements_type do
    Enum.map(elements, fn %{type: "layout", children: children} = layout ->
      updated_children =
        Enum.map(children, fn data ->
          if data.type == "section" && data.id == parent_id do
            current_Element = Enum.at(data.children, current_index)

            sorted_list =
              data.children
              |> List.delete_at(current_index)
              |> List.insert_at(new_index, current_Element)
              |> sort_elements_list(false)

            %{data | children: sorted_list}
          else
            data
          end
        end)

      %{layout | children: sort_elements_list(updated_children)}
    end)
  end

  def delete_element(elements, id, "layout") do
    elements
    |> Enum.reject(&(&1.id == id))
  end

  def delete_element(elements, id, parent_id, "section") do
    Enum.map(elements, fn %{type: "layout", children: children} = layout ->
      if layout.id == parent_id do
        sorted_list =
          children
          |> Enum.reject(&(&1.id == id))
          |> sort_elements_list(false)

        %{layout | children: sorted_list}
      else
        layout
      end
    end)
  end

  def add_tag(elements, id, _parent_id, tag, "layout") do
    Enum.map(elements, fn %{type: "layout"} = layout ->
      if layout.id == id, do: Map.merge(layout, %{tag: tag}), else: layout
    end)
  end

  def add_tag(elements, id, parent_id, tag, "section") do
    Enum.map(elements, fn %{type: "layout", children: children} = layout ->
      if layout.id == parent_id do
        edited_list =
          children
          |> Enum.map(fn el ->
            if el.id == id, do: Map.merge(el, %{tag: tag}), else: el
          end)

        %{layout | children: edited_list}
      else
        layout
      end
    end)
  end

  @spec sort_elements_list(list, boolean) :: list
  def sort_elements_list(list, auto \\ true) do
    list
    |> Enum.with_index(0)
    |> Enum.sort_by(&if(auto, do: elem(&1, 0).index, else: elem(&1, 1)))
    |> Enum.map(fn {map, index} -> Map.put(map, :index, index) end)
  end
end
