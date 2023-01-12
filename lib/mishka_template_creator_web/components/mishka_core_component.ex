defmodule MishkaTemplateCreatorWeb.MishkaCoreComponent do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :tag, :string
  attr :on_delete, JS, default: %JS{}
  attr :on_duplicate, JS, default: %JS{}

  @spec layout(map) :: Phoenix.LiveView.Rendered.t()
  def layout(assigns) do
    ~H"""
    <div class="create-section !p-20">
      <div class="flex flex-row justify-start items-center space-x-3 absolute -left-[2px] -top-11 bg-gray-200 border border-gray-200 p-2 rounded-tr-3xl z-10 w-54">
        <.block_mobile_view block_id="" />
        <.block_dark_mod block_id="" />
        <.block_settings block_id="" />
        <.block_tag block_id="" />
        <.block_add_separator block_id="" />
        <.delete_block block_id="" />
        <.block_more block_id="" />
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
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="mobile_view"
      phx-value-type=""
      phx-value-id=""
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M10.5 1.5H8.25A2.25 2.25 0 006 3.75v16.5a2.25 2.25 0 002.25 2.25h7.5A2.25 2.25 0 0018 20.25V3.75a2.25 2.25 0 00-2.25-2.25H13.5m-3 0V3h3V1.5m-3 0h3m-3 18.75h3"
      />
    </svg>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_dark_mod(map) :: Phoenix.LiveView.Rendered.t()
  defp block_dark_mod(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="dark_mod"
      phx-value-type=""
      phx-value-id=""
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z"
      />
    </svg>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_settings(map) :: Phoenix.LiveView.Rendered.t()
  defp block_settings(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="settings"
      phx-value-type=""
      phx-value-id=""
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M11.42 15.17L17.25 21A2.652 2.652 0 0021 17.25l-5.877-5.877M11.42 15.17l2.496-3.03c.317-.384.74-.626 1.208-.766M11.42 15.17l-4.655 5.653a2.548 2.548 0 11-3.586-3.586l6.837-5.63m5.108-.233c.55-.164 1.163-.188 1.743-.14a4.5 4.5 0 004.486-6.336l-3.276 3.277a3.004 3.004 0 01-2.25-2.25l3.276-3.276a4.5 4.5 0 00-6.336 4.486c.091 1.076-.071 2.264-.904 2.95l-.102.085m-1.745 1.437L5.909 7.5H4.5L2.25 3.75l1.5-1.5L7.5 4.5v1.409l4.26 4.26m-1.745 1.437l1.745-1.437m6.615 8.206L15.75 15.75M4.867 19.125h.008v.008h-.008v-.008z"
      />
    </svg>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_tag(map) :: Phoenix.LiveView.Rendered.t()
  defp block_tag(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="tag"
      phx-value-type=""
      phx-value-id=""
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M9.568 3H5.25A2.25 2.25 0 003 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 005.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 009.568 3z"
      />
      <path stroke-linecap="round" stroke-linejoin="round" d="M6 6h.008v.008H6V6z" />
    </svg>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_add_separator(map) :: Phoenix.LiveView.Rendered.t()
  defp block_add_separator(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="add_separator"
      phx-value-type=""
      phx-value-id=""
    >
      <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
    </svg>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec delete_block(map) :: Phoenix.LiveView.Rendered.t()
  defp delete_block(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 text-red-600 cursor-pointer"
      phx-click=""
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"
      />
    </svg>
    """
  end

  attr :block_id, :string, required: true
  attr :custom_class, :string, required: false
  attr :on_click, JS, default: %JS{}

  @spec block_more(map) :: Phoenix.LiveView.Rendered.t()
  defp block_more(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 6.75a.75.75 0 110-1.5.75.75 0 010 1.5zM12 12.75a.75.75 0 110-1.5.75.75 0 010 1.5zM12 18.75a.75.75 0 110-1.5.75.75 0 010 1.5z"
      />
    </svg>
    """
  end
end
