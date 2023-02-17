defmodule MishkaTemplateCreatorWeb.MishkaCoreComponent do
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  alias MishkaTemplateCreator.Components.Elements.Section

  alias MishkaTemplateCreator.Components.Blocks.{
    AddSeparator,
    DarkMod,
    Delete,
    MobileView,
    Settings,
    ShowMore,
    Tag,
    ElementMenu
  }

  @elements_type ["text", "tabs"]

  @spec aside_menu(map) :: Phoenix.LiveView.Rendered.t()
  def aside_menu(assigns) do
    ~H"""
    <ElementMenu.aside_menu />
    """
  end

  attr :id, :string, required: true
  attr :selected, :string, required: true
  attr :tag, :string, default: nil
  attr :submit, :boolean, default: false
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}
  attr :children, :list, default: []

  @spec layout(map) :: Phoenix.LiveView.Rendered.t()
  def layout(assigns) do
    ~H"""
    <div class="create-layout group" id={"layout-#{@id}"} data-type="layout">
      <div class="flex flex-row justify-start items-center space-x-3 absolute -left-[2px] -top-11 bg-gray-200 border border-gray-200 p-2 rounded-tr-3xl z-1 w-54">
        <MobileView.block_mobile_view block_id={@id} />
        <DarkMod.block_dark_mod block_id={@id} />
        <Settings.block_settings block_id={@id} />
        <Tag.block_tag block_id={@id} submit={@submit} />
        <div :if={@tag}><strong>Tag: </strong><%= @tag %></div>
        <AddSeparator.block_add_separator block_id={@id} />
        <Delete.delete_block block_id={@id} />
        <ShowMore.block_more block_id={@id} />
      </div>
      <div
        id={@id}
        class={"flex flex-row justify-start items-center w-full space-x-3 px-3 #{if length(@children) == 0, do: "py-10"}"}
        data-type="layout"
      >
        <Section.section
          :for={child <- @children}
          id={child.id}
          children={child.children}
          selected={@selected}
          parent_id={@id}
          submit={@submit}
          tag={Map.get(child, :tag)}
        />
      </div>
    </div>
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
