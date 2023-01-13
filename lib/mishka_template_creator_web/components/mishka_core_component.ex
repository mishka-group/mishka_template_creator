defmodule MishkaTemplateCreatorWeb.MishkaCoreComponent do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :id, :string, default: "layout-#{Ecto.UUID.generate()}"
  attr :tag, :string, default: nil
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}

  @spec layout(map) :: Phoenix.LiveView.Rendered.t()
  def layout(assigns) do
    ~H"""
    <div class="create-section !p-20" id={@id} data-type={@tag || @id}>
      <div class="flex flex-row justify-start items-center space-x-3 absolute -left-[2px] -top-11 bg-gray-200 border border-gray-200 p-2 rounded-tr-3xl z-10 w-54">
        <.block_mobile_view block_id={@id} />
        <.block_dark_mod block_id={@id} />
        <.block_settings block_id={@id} />
        <.block_tag block_id={@id} />
        <.block_add_separator block_id={@id} />
        <.delete_block block_id={@id} />
        <.block_more block_id={@id} />
      </div>
    </div>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_mobile_view(map) :: Phoenix.LiveView.Rendered.t()
  defp block_mobile_view(assigns) do
    ~H"""
    <img
      src="/images/mobile.svg"
      alt="Show mobile view"
      class="w-6 h-6 cursor-pointer"
      phx-click="mobile_view"
      phx-value-type=""
      phx-value-id=""
    />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_dark_mod(map) :: Phoenix.LiveView.Rendered.t()
  defp block_dark_mod(assigns) do
    ~H"""
    <img
      src="/images/dark_mod.svg"
      alt="Show dark mode or light one"
      class="w-6 h-6 cursor-pointer"
      phx-click="dark_mod"
      phx-value-type=""
      phx-value-id=""
    />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_settings(map) :: Phoenix.LiveView.Rendered.t()
  defp block_settings(assigns) do
    ~H"""
    <img
      src="/images/settings.svg"
      alt="Show dark mode or light one"
      class="w-6 h-6 cursor-pointer"
      phx-click="dark_mod"
      phx-value-type=""
      phx-value-id=""
    />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_tag(map) :: Phoenix.LiveView.Rendered.t()
  defp block_tag(assigns) do
    ~H"""
    <img
      src="/images/tag.svg"
      alt="Show dark mode or light one"
      class="w-6 h-6 cursor-pointer"
      phx-click="dark_mod"
      phx-value-type=""
      phx-value-id=""
    />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_add_separator(map) :: Phoenix.LiveView.Rendered.t()
  defp block_add_separator(assigns) do
    ~H"""
    <img
      src="/images/plus.svg"
      alt="Show dark mode or light one"
      class="w-6 h-6 cursor-pointer"
      phx-click="dark_mod"
      phx-value-type=""
      phx-value-id=""
    />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec delete_block(map) :: Phoenix.LiveView.Rendered.t()
  defp delete_block(assigns) do
    ~H"""
    <img
      src="/images/trash.svg"
      alt="Show dark mode or light one"
      class="w-6 h-6 cursor-pointer bg-red text-red"
      phx-click="dark_mod"
      phx-value-type=""
      phx-value-id=""
    />
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_more(map) :: Phoenix.LiveView.Rendered.t()
  defp block_more(assigns) do
    ~H"""
    <img
      src="/images/more.svg"
      alt="Show dark mode or light one"
      class="w-6 h-6 cursor-pointer bg-red text-red"
      phx-click="dark_mod"
      phx-value-type=""
      phx-value-id=""
    />
    """
  end
end
