defmodule MishkaTemplateCreatorWeb.MishkaCoreComponent do
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import MishkaTemplateCreatorWeb.CoreComponents

  @elements_type ["text", "tabs"]

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :rest, :global

  slot :inner_block, required: true

  @spec element(map) :: Phoenix.LiveView.Rendered.t()
  def element(assigns) do
    ~H"""
    <div
      data-id={@id}
      data-type={@id}
      class="border border-gray-200 rounded-md p-5 hover:border hover:border-blue-300 hover:duration-300 duration-1000 hover:text-blue-500 lg:px-1"
      {@rest}
    >
      <p class="mx-auto text-center">
        <%= render_slot(@inner_block) %>
      </p>
      <p class="text-xs font-bold mt-5 text-center"><%= @title %></p>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :tag, :string, default: nil
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}
  attr :children, :list, default: []

  @spec layout(map) :: Phoenix.LiveView.Rendered.t()
  def layout(assigns) do
    ~H"""
    <div class="create-section" id={"layout-#{@id}"}>
      <div class="flex flex-row justify-start items-center space-x-3 absolute -left-[2px] -top-11 bg-gray-200 border border-gray-200 p-2 rounded-tr-3xl z-1 w-54">
        <.block_mobile_view block_id={@id} />
        <.block_dark_mod block_id={@id} />
        <.block_settings block_id={@id} />
        <.block_tag block_id={@id} />
        <.block_add_separator block_id={@id} />
        <.delete_block block_id={@id} />
        <.block_more block_id={@id} />
      </div>
      <div
        id={@id}
        class={"flex flex-row justify-start items-center w-full space-x-3 px-3 #{if length(@children) == 0, do: "py-10"}"}
        data-type="layout"
        data-tag={@tag || @id}
      >
        <.section :for={child <- @children} id={child.id} children={child.children} />
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :tag, :string, default: nil
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}
  attr :rest, :global
  attr :children, :list, default: []

  @spec section(map) :: Phoenix.LiveView.Rendered.t()
  def section(assigns) do
    ~H"""
    <div class="create-sub-section" id={@id} data-type="section" data-tag={@tag || @id}>
      <p :for={_child <- @children}>test</p>
    </div>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_mobile_view(map) :: Phoenix.LiveView.Rendered.t()
  defp block_mobile_view(assigns) do
    ~H"""
    <Heroicons.device_phone_mobile class="layout-icons" />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_dark_mod(map) :: Phoenix.LiveView.Rendered.t()
  defp block_dark_mod(assigns) do
    ~H"""
    <Heroicons.sun class="layout-icons" />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_settings(map) :: Phoenix.LiveView.Rendered.t()
  defp block_settings(assigns) do
    ~H"""
    <Heroicons.wrench_screwdriver class="layout-icons" />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_tag(map) :: Phoenix.LiveView.Rendered.t()
  defp block_tag(assigns) do
    ~H"""
    <Heroicons.tag class="layout-icons" />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_add_separator(map) :: Phoenix.LiveView.Rendered.t()
  defp block_add_separator(assigns) do
    ~H"""
    <Heroicons.plus class="layout-icons" />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec delete_block(map) :: Phoenix.LiveView.Rendered.t()
  defp delete_block(assigns) do
    ~H"""
    <Heroicons.trash
      class="layout-icons text-red-500"
      phx-click={show_modal("delete_confirm-#{@block_id}")}
    />
    <.modal
      id={"delete_confirm-#{@block_id}"}
      on_confirm={
        JS.push("delete", value: %{id: @block_id, type: "layout"})
        |> hide_modal("delete_confirm-#{@block_id}")
      }
    >
      Are you sure?
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_more(map) :: Phoenix.LiveView.Rendered.t()
  defp block_more(assigns) do
    ~H"""
    <Heroicons.ellipsis_vertical class="layout-icons" />
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

  def sort_elements_list(list) do
    list
    |> Enum.with_index(0)
    |> Enum.sort_by(fn {x, _y} -> x.index end)
    |> Enum.map(fn {map, index} -> Map.put(map, :index, index) end)
  end

  def change_order(elements, current_index, new_index, "layout") do
    current_Element = Enum.at(elements, current_index)

    elements
    |> List.delete_at(current_index)
    |> List.insert_at(new_index, current_Element)
    |> Enum.with_index(0)
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.map(fn {map, index} -> Map.put(map, :index, index) end)
  end
end
