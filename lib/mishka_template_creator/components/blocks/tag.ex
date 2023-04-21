defmodule MishkaTemplateCreator.Components.Blocks.Tag do
  use Phoenix.Component
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  import Phoenix.HTML.Form
  alias Phoenix.LiveView.JS

  attr :block_id, :string, required: true
  attr :type, :string, required: false, default: "layout"
  attr :parent_id, :string, required: false, default: nil
  attr :submit, :boolean, default: false
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_tag(map) :: Phoenix.LiveView.Rendered.t()
  def block_tag(assigns) do
    ~H"""
    <Heroicons.tag class={@custom_class} phx-click={show_modal("#{@type}-tag-#{@block_id}")} />
    <.modal id={"#{@type}-tag-#{@block_id}"}>
      <.simple_form :let={f} for={%{}} as={:tag} phx-submit="element" phx-change="validate">
        <.input field={f[:tag]} label="Tag Name" id={"field-tag-#{@type}-#{@block_id}"} />
        <p class={"text-sm #{if @submit, do: "text-red-500", else: ""}"}>
          Please use only letters and numbers in naming and also keep in mind that you can only use (<code class="text-pink-400">-</code>) between letters. It should be noted, the tag name must be more than 4 characters.
        </p>
        <.input field={f[:type]} type="hidden" value={@type} id={"field-type-#{@type}-#{@block_id}"} />
        <.input field={f[:id]} type="hidden" value={@block_id} id={"field-id-#{@type}-#{@block_id}"} />
        <.input
          field={f[:parent_id]}
          type="hidden"
          value={@parent_id}
          id={"field-parent_id-#{@type}-#{@block_id}"}
        />
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

  attr(:myself, :integer, required: true)
  attr(:value, :any, required: true)
  attr(:id, :string, required: true)
  attr(:as, :atom, required: false, default: :public_tab_tag)
  attr(:submit_event, :string, required: false, default: "element")
  attr(:change_event, :string, required: false, default: "validate")
  attr(:placeholder, :string, required: false, default: "Change Tag name")
  attr(:submit, :boolean, default: false)

  attr(:class, :string,
    required: false,
    default: "flex flex-col w-full items-center justify-center pb-5"
  )
  attr(:text_input_class, :string,
    required: false,
    default: "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500"
  )

  def input_tag(assigns) do
    ~H"""
    <div class={@class}>
      <MishkaCoreComponent.custom_simple_form
        :let={f}
        for={%{}}
        as={@as}
        phx-change={@change_event}
        phx-submit={@submit_event}
        phx-target={@myself}
        class="w-full m-0 p-0 flex flex-col"
      >
        <%= text_input(f, :tag,
          class: @text_input_class,
          placeholder: @placeholder,
          value: @value,
          id: "#{Atom.to_string(@as)}-#{@id}"
        ) %>
        <p class={"text-xs #{if @submit, do: "text-red-500", else: ""} my-3 text-justify"}>
          Please use only letters and numbers in naming and also keep in mind that you can only use (<code class="text-pink-400">-</code>) between letters. It should be noted, the tag name must be more than 4 characters.
        </p>
      </MishkaCoreComponent.custom_simple_form>
    </div>
    """
  end
end
