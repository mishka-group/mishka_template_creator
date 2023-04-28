defmodule MishkaTemplateCreator.Data.Elements do
  @layout_items [
    {"layout", "Layout", "Heroicons.inbox_stack", ["dragLocation"]},
    {"section", "Section", "Heroicons.inbox_stack", ["layout", "section"]},
    {"text", "Text", "Heroicons.inbox_stack", ["section"]},
    {"tab", "Tab", "Heroicons.inbox_stack", ["section"]},
    {"table", "Table", "Heroicons.inbox_stack", ["section"]},
    {"accordion", "Accordion", "Heroicons.inbox_stack", ["section"]},
    {"button", "Button", "Heroicons.inbox_stack", ["section"]}
  ]

  @elements_items [
    {"alert", "Alert", "Heroicons.inbox_stack", ["section"]},
    {"quote", "Quote", "Heroicons.inbox_stack", ["section"]},
    {"code", "Code", "Heroicons.inbox_stack", ["section"]},
    {"card", "Card", "Heroicons.inbox_stack", ["section"]}
  ]

  @media_items [
    {"image", "Image", "Heroicons.inbox_stack", ["section"]},
    {"video", "Video", "Heroicons.inbox_stack", ["section"]},
    {"gallery", "Gallery", "Heroicons.inbox_stack", ["section"]},
    {"thumbnails", "Thumbnails", "Heroicons.inbox_stack", ["section"]},
    {"audio", "Audio", "Heroicons.inbox_stack", ["section"]},
    {"file", "File", "Heroicons.inbox_stack", ["section"]},
    {"pdf", "PDF", "Heroicons.inbox_stack", ["section"]},
    {"comparison", "Comparison", "Heroicons.inbox_stack", ["section"]},
    {"links", "Links", "Heroicons.inbox_stack", ["section"]}
  ]

  @spec elements :: [{String.t(), String.t(), String.t(), list(String.t())}]
  def elements(), do: @layout_items ++ @elements_items ++ @media_items

  @spec elements(:elements_items | :layout_items | :media_items) :: [
          {String.t(), String.t(), String.t(), list(String.t())}
        ]
  def elements(:layout_items), do: @layout_items
  def elements(:elements_items), do: @elements_items
  def elements(:media_items), do: @media_items

  @spec elements(:all | :elements_items | :layout_items | :media_items, :id) :: list(String.t())
  def elements(:all, :id), do: elements() |> Enum.map(fn {id, _, _, _} -> id end)
  def elements(type, :id), do: elements(type) |> Enum.map(fn {id, _, _, _} -> id end)
end
