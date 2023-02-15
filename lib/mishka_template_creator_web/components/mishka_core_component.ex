defmodule MishkaTemplateCreatorWeb.MishkaCoreComponent do
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import MishkaTemplateCreatorWeb.CoreComponents

  @elements_type ["text", "tabs"]

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :rest, :global

  slot :inner_block, required: true

  @spec block(map) :: Phoenix.LiveView.Rendered.t()
  def block(assigns) do
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
  attr :selected, :string, required: true
  attr :tag, :string, default: nil
  attr :submit, :boolean, default: false
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}
  attr :children, :list, default: []

  @spec layout(map) :: Phoenix.LiveView.Rendered.t()
  def layout(assigns) do
    ~H"""
    <div class="create-layout" id={"layout-#{@id}"} data-type="layout">
      <div class="flex flex-row justify-start items-center space-x-3 absolute -left-[2px] -top-11 bg-gray-200 border border-gray-200 p-2 rounded-tr-3xl z-1 w-54">
        <.block_mobile_view block_id={@id} />
        <.block_dark_mod block_id={@id} />
        <.block_settings block_id={@id} />
        <.block_tag block_id={@id} submit={@submit} />
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
        <.section
          :for={child <- @children}
          id={child.id}
          children={child.children}
          selected={@selected}
          parent_id={@id}
        />
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :parent_id, :string, required: true
  attr :selected, :string, required: true
  attr :tag, :string, default: nil
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}
  attr :rest, :global
  attr :children, :list, default: []

  @spec section(map) :: Phoenix.LiveView.Rendered.t()
  def section(assigns) do
    ~H"""
    <div
      class={"relative create-section #{if @selected === @id, do: "bg-white rounded-sm"}"}
      id={@id}
      data-type="section"
      data-tag={@tag || @id}
      phx-click="edit_section"
      phx-value-id={@id}
    >
      <%= if @selected === @id do %>
        <.section_header section_id={@id} parent_id={@parent_id} />
      <% end %>
      <.element :for={child <- @children} type={child.type} id={child.id} />
    </div>
    """
  end

  attr :id, :string, required: true
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}
  attr :rest, :global

  def element(%{rest: %{type: "text"}} = assigns) do
    ~H"""
    <p data-type="text" id={"text-#{@id}"} phx-click="edit_element" phx-value-id={"text-#{@id}"}>
      text
    </p>
    """
  end

  def element(%{rest: %{type: "tabs"}} = assigns) do
    ~H"""
    <p data-type="tabs" id={"tabs-#{@id}"}>tabs</p>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_mobile_view(map) :: Phoenix.LiveView.Rendered.t()
  defp block_mobile_view(assigns) do
    ~H"""
    <Heroicons.device_phone_mobile class={@custom_class} />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_dark_mod(map) :: Phoenix.LiveView.Rendered.t()
  defp block_dark_mod(assigns) do
    ~H"""
    <Heroicons.sun class={@custom_class} />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_settings(map) :: Phoenix.LiveView.Rendered.t()
  defp block_settings(assigns) do
    ~H"""
    <Heroicons.wrench_screwdriver class={@custom_class} />
    """
  end

  attr :block_id, :string, required: true
  attr :type, :string, required: false, default: "layout"
  attr :parent_id, :string, required: false, default: nil
  attr :submit, :boolean, default: false
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_tag(map) :: Phoenix.LiveView.Rendered.t()
  defp block_tag(assigns) do
    ~H"""
    <Heroicons.tag class={@custom_class} phx-click={show_modal("#{@type}-tag-#{@block_id}")} />
    <.modal id={"#{@type}-tag-#{@block_id}"}>
      <.simple_form :let={f} for={:user} phx-submit="save_tag" phx-change="validate_tag">
        <.input field={{f, :tag}} label="Tag Name" />
        <p class={"text-sm #{if @submit, do: "text-red-500", else: ""}"}>
          Please use only letters and numbers in naming and also keep in mind that you can only use (<code class="text-pink-400">-</code>) between letters. It should be noted, the tag name must be more than 4 characters.
        </p>
        <.input field={{f, :type}} type="hidden" value={@type} />
        <.input field={{f, :id}} type="hidden" value={@block_id} />
        <.input field={{f, :parent_id}} type="hidden" value={@parent_id} />
        <:actions>
          <.button
            class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 disabled:bg-gray-400 disabled:text-white disabled:outline-none"
            disabled={@submit}
            phx-click={if !@submit, do: hide_modal("#{@type}-tag-#{@block_id}"), else: nil}
          >
            Save
          </.button>
        </:actions>
      </.simple_form>
    </.modal>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_add_separator(map) :: Phoenix.LiveView.Rendered.t()
  defp block_add_separator(assigns) do
    ~H"""
    <Heroicons.plus class={@custom_class} />
    """
  end

  attr :block_id, :string, required: true
  attr :parent_id, :string, required: false, default: nil
  attr :type, :string, required: false, default: "layout"
  attr :custom_class, :string, required: false, default: "layout-icons text-red-500"
  attr :on_click, JS, default: %JS{}

  @spec delete_block(map) :: Phoenix.LiveView.Rendered.t()
  defp delete_block(assigns) do
    ~H"""
    <Heroicons.trash class={@custom_class} phx-click={show_modal("delete_confirm-#{@block_id}")} />
    <.modal
      id={"delete_confirm-#{@block_id}"}
      on_confirm={
        JS.push("delete", value: %{id: @block_id, type: @type, parent_id: @parent_id})
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
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_more(map) :: Phoenix.LiveView.Rendered.t()
  defp block_more(assigns) do
    ~H"""
    <Heroicons.ellipsis_vertical class={@custom_class} />
    """
  end

  attr :section_id, :string, required: true
  attr :parent_id, :string, required: true

  @spec section_header(map) :: Phoenix.LiveView.Rendered.t()
  defp section_header(assigns) do
    ~H"""
    <div id={"section_header_#{@section_id}"} class="section-header">
      <.block_settings block_id={@section_id} custom_class="section-icons" />
      <.block_tag
        block_id={@section_id}
        custom_class="section-icons"
        type="section"
        parent_id={@parent_id}
      />
      <.block_add_separator block_id={@section_id} custom_class="section-icons" />
      <.delete_block
        block_id={@section_id}
        custom_class="section-icons text-red-500"
        type="section"
        parent_id={@parent_id}
      />
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
