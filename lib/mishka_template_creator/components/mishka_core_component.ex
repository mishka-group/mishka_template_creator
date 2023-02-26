defmodule MishkaTemplateCreatorWeb.MishkaCoreComponent do
  use Phoenix.Component
  alias MishkaTemplateCreator.Components.Blocks.{Content, Aside}

  @elements_type ["text", "tabs"]

  attr :elemens, :list, required: true
  attr :selected_block, :string, required: true
  attr :selected_setting, :map, required: false, default: nil
  attr :submit, :string, required: true

  @spec dashboard(map) :: Phoenix.LiveView.Rendered.t()
  def dashboard(assigns) do
    ~H"""
    <div class="main-body" phx-click="reset">
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
        <Content.content elemens={@elemens} selected_block={@selected_block} submit={@submit} />
        <Aside.aside />
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
