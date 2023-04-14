defmodule MishkaTemplateCreator.Components.Elements.Tab do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  alias MishkaTemplateCreator.Components.Blocks.Aside
  alias MishkaTemplateCreatorWeb.MishkaCoreComponent
  import MishkaTemplateCreatorWeb.CoreComponents
  alias MishkaTemplateCreator.Data.TailwindSetting

  # TODO: Add new tab and it's text
  # TODO: Tabs Title
  # TODO: Tabs Title icon
  # TODO: Tabs Title icon all style like text component
  # TODO: Tab title font size
  # TODO: Tab text all styles like text component
  # TODO: Show tab tree to manage and edit all of them with click
  # ---------------------------------------------------------------------------------------------------------------
  # TODO: Presets which are added with MishkaInstaller as a plugin, it let user select pre-prepared tabs. in V0.0.2
  %{
    "unique_id" => %{
      "children" => %{
        "unique_id-0" => %{"title" => "", "html" => "", "icon" => ""},
        "unique_id-1" => %{"title" => "", "html" => "", "icon" => ""}
      },
      "header" => %{
        "container" => "",
        "title" => "",
        "icon" => "",
        "button" => ""
      },
      "content" => "",
      "order" => ["unique_id-0", "unique_id-1"],
      "class" => "",
      "type" => "tab",
      "parent" => "section",
      "parent_id" => "unique_id"
    }
  }

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(%{render_type: "call"} = assigns) do
    ~H"""
    <div
      data-type="tab"
      id={"tab-#{@id}"}
      data-id={String.replace(@id, "-call", "")}
      data-parent-type="section"
      class={@element["class"]}
    >
      <ul class={Enum.join(@element["header"]["container"], " ")}>
        <li>
          <button class={Enum.join(@element["header"]["button"], " ")} type="button">
            <Heroicons.adjustments_horizontal class={Enum.join(@element["header"]["icon"], " ")} />
            <span class={Enum.join(@element["header"]["title"], " ")}>Profile</span>
          </button>
        </li>
      </ul>

      <div class={Enum.join(@element["content"], " ")}>
        <p>
          This is some placeholder content the <strong class="font-medium text-gray-800 dark:text-white">Profile tab's associated content</strong>. Clicking another tab will toggle the visibility of this one for the next. The tab JavaScript swaps classes to control the content visibility and styling.
        </p>
      </div>
    </div>
    """
  end

  def render(%{render_type: "form"} = assigns) do
    ~H"""
    <div>form</div>
    """
  end
end
