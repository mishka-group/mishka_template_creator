defmodule MishkaTemplateCreator.Data.Elements do
  @layout_items [
    {"layout", "Layout", "Heroicons.inbox_stack"},
    {"section", "Section", "Heroicons.inbox_stack"},
    {"text", "Text", "Heroicons.inbox_stack"},
    {"tabs", "Tabs", "Heroicons.inbox_stack"},
    {"columns", "Columns", "Heroicons.inbox_stack"},
    {"table", "Table", "Heroicons.inbox_stack"},
    {"accordion", "Accordion", "Heroicons.inbox_stack"}
  ]
  @elements_items [
    {"alerts", "Alerts", "Heroicons.inbox_stack"},
    {"quotes", "Quotes", "Heroicons.inbox_stack"},
    {"buttons", "Buttons", "Heroicons.inbox_stack"},
    {"links", "Links", "Heroicons.inbox_stack"},
    {"code", "Code", "Heroicons.inbox_stack"},
    {"notes", "Notes", "Heroicons.inbox_stack"}
  ]
  @media_items [
    {"image", "Image", "Heroicons.inbox_stack"},
    {"video", "Video", "Heroicons.inbox_stack"},
    {"gallery", "Gallery", "Heroicons.inbox_stack"},
    {"thumbnails", "Thumbnails", "Heroicons.inbox_stack"},
    {"audio", "Audio", "Heroicons.inbox_stack"},
    {"file", "File", "Heroicons.inbox_stack"},
    {"pdf", "PDF", "Heroicons.inbox_stack"},
    {"comparison", "Comparison", "Heroicons.inbox_stack"}
  ]

  @spec elements :: [{String.t(), String.t(), String.t()}]
  def elements(), do: @layout_items ++ @elements_items ++ @media_items

  @spec elements(:elements_items | :layout_items | :media_items) :: [
          {String.t(), String.t(), String.t()}
        ]
  def elements(:layout_items), do: @layout_items
  def elements(:elements_items), do: @elements_items
  def elements(:media_items), do: @media_items

  @spec elements(:all | :elements_items | :layout_items | :media_items, :id) :: list(String.t())
  def elements(:all, :id), do: elements() |> Enum.map(fn {id, _, _} -> id end)
  def elements(type, :id), do: elements(type) |> Enum.map(fn {id, _, _} -> id end)
end
