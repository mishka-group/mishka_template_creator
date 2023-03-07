defmodule MishkaTemplateCreator.Components.Blocks.Settings do
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import MishkaTemplateCreatorWeb.CoreComponents

  import MishkaTemplateCreatorWeb.MishkaCoreComponent
  alias MishkaTemplateCreator.Components.Blocks.ElementMenu

  @tailwind_layout_settings [
    {"layout", "Layout", "Heroicons.inbox_stack",
     [
       {"z-Index", "Z-Index", "Utilities for controlling the stack order of an element.",
        [
          "z-0",
          "z-10",
          "z-20",
          "z-30",
          "z-40",
          "z-50",
          "z-auto",
          "-z-0",
          "-z-10",
          "-z-20",
          "-z-30",
          "-z-40",
          "-z-50"
        ], [:hover, :media_queries]},
       {"visibility", "Visibility",
        "Utilities for controlling the placement of positioned elements.",
        [
          "visible",
          "invisible",
          "collapse"
        ], [:hover, :media_queries]},
       {"top-right-bottom-left", "Top / Right / Bottom / Left",
        "Utilities for controlling the placement of positioned elements.",
        [
          "inset-0",
          "inset-x-0",
          "inset-y-0",
          "top-0",
          "right-0",
          "bottom-0",
          "left-0",
          "inset-px",
          "inset-x-px",
          "inset-y-px",
          "top-px",
          "right-px",
          "bottom-px",
          "left-px",
          "inset-0.5",
          "inset-x-0.5",
          "inset-y-0.5",
          "top-0.5",
          "right-0.5",
          "bottom-0.5",
          "left-0.5",
          "inset-1",
          "inset-x-1",
          "inset-y-1",
          "top-1",
          "right-1",
          "bottom-1",
          "left-1",
          "inset-1.5",
          "inset-x-1.5",
          "inset-y-1.5",
          "top-1.5",
          "right-1.5",
          "bottom-1.5",
          "left-1.5",
          "inset-2",
          "inset-x-2",
          "inset-y-2",
          "top-2",
          "right-2",
          "bottom-2",
          "left-2",
          "inset-2.5",
          "inset-x-2.5",
          "inset-y-2.5",
          "top-2.5",
          "right-2.5",
          "bottom-2.5",
          "left-2.5",
          "inset-3",
          "inset-x-3",
          "inset-y-3",
          "top-3",
          "right-3",
          "bottom-3",
          "left-3",
          "inset-3.5",
          "inset-x-3.5",
          "inset-y-3.5",
          "top-3.5",
          "right-3.5",
          "bottom-3.5",
          "left-3.5",
          "inset-4",
          "inset-x-4",
          "inset-y-4",
          "top-4",
          "right-4",
          "bottom-4",
          "left-4",
          "inset-5",
          "inset-x-5",
          "inset-y-5",
          "top-5",
          "right-5",
          "bottom-5",
          "left-5",
          "inset-6",
          "inset-x-6",
          "inset-y-6",
          "top-6",
          "right-6",
          "bottom-6",
          "left-6",
          "inset-7",
          "inset-x-7",
          "inset-y-7",
          "top-7",
          "right-7",
          "bottom-7",
          "left-7",
          "inset-8",
          "inset-x-8",
          "inset-y-8",
          "top-8",
          "right-8",
          "bottom-8",
          "left-8",
          "inset-9",
          "inset-x-9",
          "inset-y-9",
          "top-9",
          "right-9",
          "bottom-9",
          "left-9",
          "inset-10",
          "inset-x-10",
          "inset-y-10",
          "top-10",
          "right-10",
          "bottom-10",
          "left-10",
          "inset-11",
          "inset-x-11",
          "inset-y-11",
          "top-11",
          "right-11",
          "bottom-11",
          "left-11",
          "inset-12",
          "inset-x-12",
          "inset-y-12",
          "top-12",
          "right-12",
          "bottom-12",
          "left-12",
          "inset-14",
          "inset-x-14",
          "inset-y-14",
          "top-14",
          "right-14",
          "bottom-14",
          "left-14",
          "inset-16",
          "inset-x-16",
          "inset-y-16",
          "top-16",
          "right-16",
          "bottom-16",
          "left-16",
          "inset-20",
          "inset-x-20",
          "inset-y-20",
          "top-20",
          "right-20",
          "bottom-20",
          "left-20",
          "inset-24",
          "inset-x-24",
          "inset-y-24",
          "top-24",
          "right-24",
          "bottom-24",
          "left-24",
          "inset-28",
          "inset-x-28",
          "inset-y-28",
          "top-28",
          "right-28",
          "bottom-28",
          "left-28",
          "inset-32",
          "inset-x-32",
          "inset-y-32",
          "top-32",
          "right-32",
          "bottom-32",
          "left-32",
          "inset-36",
          "inset-x-36",
          "inset-y-36",
          "top-36",
          "right-36",
          "bottom-36",
          "left-36",
          "inset-40",
          "inset-x-40",
          "inset-y-40",
          "top-40",
          "right-40",
          "bottom-40",
          "left-40",
          "inset-44",
          "inset-x-44",
          "inset-y-44",
          "top-44",
          "right-44",
          "bottom-44",
          "left-44",
          "inset-48",
          "inset-x-48",
          "inset-y-48",
          "top-48",
          "right-48",
          "bottom-48",
          "left-48",
          "inset-52",
          "inset-x-52",
          "inset-y-52",
          "top-52",
          "right-52",
          "bottom-52",
          "left-52",
          "inset-56",
          "inset-x-56",
          "inset-y-56",
          "top-56",
          "right-56",
          "bottom-56",
          "left-56",
          "inset-60",
          "inset-x-60",
          "inset-y-60",
          "top-60",
          "right-60",
          "bottom-60",
          "left-60",
          "inset-64",
          "inset-x-64",
          "inset-y-64",
          "top-64",
          "right-64",
          "bottom-64",
          "left-64",
          "inset-72",
          "inset-x-72",
          "inset-y-72",
          "top-72",
          "right-72",
          "bottom-72",
          "left-72",
          "inset-80",
          "inset-x-80",
          "inset-y-80",
          "top-80",
          "right-80",
          "bottom-80",
          "left-80",
          "inset-96",
          "inset-x-96",
          "inset-y-96",
          "top-96",
          "right-96",
          "bottom-96",
          "left-96",
          "inset-auto",
          "inset-1/2",
          "inset-1/3",
          "inset-2/3",
          "inset-1/4",
          "inset-2/4",
          "inset-3/4",
          "inset-full",
          "inset-x-auto",
          "inset-x-1/2",
          "inset-x-1/3",
          "inset-x-2/3",
          "inset-x-1/4",
          "inset-x-2/4",
          "inset-x-3/4",
          "inset-x-full",
          "inset-y-auto",
          "inset-y-1/2",
          "inset-y-1/3",
          "inset-y-2/3",
          "inset-y-1/4",
          "inset-y-2/4",
          "inset-y-3/4",
          "inset-y-full",
          "top-auto",
          "top-1/2",
          "top-1/3",
          "top-2/3",
          "top-1/4",
          "top-2/4",
          "top-3/4",
          "top-full",
          "right-auto",
          "right-1/2",
          "right-1/3",
          "right-2/3",
          "right-1/4",
          "right-2/4",
          "right-3/4",
          "right-full",
          "bottom-auto",
          "bottom-1/2",
          "bottom-1/3",
          "bottom-2/3",
          "bottom-1/4",
          "bottom-2/4",
          "bottom-3/4",
          "bottom-full",
          "left-auto",
          "left-1/2",
          "left-1/3",
          "left-2/3",
          "left-1/4",
          "left-2/4",
          "left-3/4",
          "left-full"
        ], [:hover, :media_queries]},
       {"position", "Position",
        "Utilities for controlling how an element is positioned in the DOM.",
        [
          "static",
          "fixed",
          "absolute",
          "relative",
          "sticky"
        ], [:hover, :media_queries]},
       {"overscroll-behavior", "Overscroll Behavior",
        "Utilities for controlling how the browser behaves when reaching the boundary of a scrolling area.",
        [
          "overscroll-auto",
          "overscroll-contain",
          "overscroll-none",
          "overscroll-y-auto",
          "overscroll-y-contain",
          "overscroll-y-none",
          "overscroll-x-auto",
          "overscroll-x-contain",
          "overscroll-x-none"
        ], [:hover, :media_queries]},
       {"overflow", "Overflow",
        "Utilities for controlling how an element handles content that is too large for the container.",
        [
          "overflow-auto",
          "overflow-hidden",
          "overflow-clip",
          "overflow-visible",
          "overflow-scroll",
          "overflow-x-auto",
          "overflow-y-auto",
          "overflow-x-hidden",
          "overflow-y-hidden",
          "overflow-x-clip",
          "overflow-y-clip",
          "overflow-x-visible",
          "overflow-y-visible",
          "overflow-x-scroll",
          "overflow-y-scroll"
        ], [:hover, :media_queries]},
       {"object-position", "Object Position",
        "Utilities for controlling how a replaced element's content should be positioned within its container.",
        [
          "object-bottom",
          "object-center",
          "object-left",
          "object-left-bottom",
          "object-left-top",
          "object-right",
          "object-right-bottom",
          "object-right-top",
          "object-top"
        ], [:hover, :media_queries]},
       {"object-fit", "Object Fit",
        "Utilities for controlling how a replaced element's content should be resized.",
        [
          "object-contain",
          "object-cover",
          "object-fill",
          "object-none",
          "object-scale-down"
        ], [:hover, :media_queries]},
       {"isolation", "Isolation",
        "Utilities for controlling whether an element should explicitly create a new stacking context.",
        [
          "isolate",
          "isolation-auto"
        ], [:hover, :media_queries]},
       {"clear", "Clear", "Utilities for controlling the wrapping of content around an element.",
        [
          "clear-left",
          "clear-right",
          "clear-both",
          "clear-none"
        ], [:hover, :media_queries]},
       {"floats", "Floats",
        "Utilities for controlling the wrapping of content around an element.",
        [
          "float-right",
          "float-left",
          "float-none"
        ], [:hover, :media_queries]},
       {"display", "Display", "Utilities for controlling the display box type of an element.",
        [
          "block",
          "inline-block",
          "inline",
          "flex",
          "inline-flex",
          "table",
          "inline-table",
          "table-caption",
          "table-cell",
          "table-column",
          "table-column-group",
          "table-footer-group",
          "table-header-group",
          "table-row-group",
          "table-row",
          "flow-root",
          "grid",
          "inline-grid",
          "contents",
          "list-item",
          "hidden"
        ], [:hover, :media_queries]},
       {"box-sizing", "Box Sizing",
        "Utilities for controlling how the browser should calculate an element's total size.",
        [
          "box-border",
          "box-content"
        ], [:hover, :media_queries]},
       {"box-decoration-break", "Box Decoration Break",
        "Utilities for controlling how element fragments should be rendered across multiple lines, columns, or pages.",
        [
          "box-decoration-clone",
          "box-decoration-slice"
        ], [:hover, :media_queries]},
       {"break-inside", "Break Inside",
        "Utilities for controlling how a column or page should break within an element.",
        [
          "break-inside-auto",
          "break-inside-avoid",
          "break-inside-avoid-page",
          "break-inside-avoid-column"
        ], [:hover, :media_queries]},
       {"break-before", "Break Before",
        "Utilities for controlling how a column or page should break before an element.",
        [
          "break-before-auto",
          "break-before-avoid",
          "break-before-all",
          "break-before-avoid-page",
          "break-before-page",
          "break-before-left",
          "break-before-right",
          "break-before-column"
        ], [:hover, :media_queries]},
       {"break-after", "Break After",
        "Utilities for controlling how a column or page should break after an element.",
        [
          "break-after-auto",
          "break-after-avoid",
          "break-after-all",
          "break-after-avoid-page",
          "break-after-page",
          "break-after-left",
          "break-after-right",
          "break-after-column"
        ], [:hover, :media_queries]},
       {"columns", "Columns",
        "Utilities for controlling the number of columns within an element.",
        [
          "columns-1",
          "columns-2",
          "columns-3",
          "columns-4",
          "columns-5",
          "columns-6",
          "columns-7",
          "columns-8",
          "columns-9",
          "columns-10",
          "columns-11",
          "columns-12",
          "columns-auto",
          "columns-3xs",
          "columns-2xs",
          "columns-xs",
          "columns-sm",
          "columns-md",
          "columns-lg",
          "columns-xl",
          "columns-2xl",
          "columns-3xl",
          "columns-4xl",
          "columns-5xl",
          "columns-6xl",
          "columns-7xl"
        ], [:hover, :media_queries]},
       {"aspect-ratio", "Aspect Ratio",
        "Utilities for controlling the aspect ratio of an element.",
        [
          "aspect-auto",
          "aspect-square",
          "aspect-video"
        ], [:hover, :media_queries]}
     ]},
    {"flexbox_grid", "Flexbox & Grid", "Heroicons.circle_stack",
     [
       {"flex-basis", "Flex Basis", "Utilities for controlling the initial size of flex items.",
        [
          "basis-0",
          "basis-1",
          "basis-2",
          "basis-3",
          "basis-4",
          "basis-5",
          "basis-6",
          "basis-7",
          "basis-8",
          "basis-9",
          "basis-10",
          "basis-11",
          "basis-12",
          "basis-14",
          "basis-16",
          "basis-20",
          "basis-24",
          "basis-28",
          "basis-32",
          "basis-36",
          "basis-40",
          "basis-44",
          "basis-48",
          "basis-52",
          "basis-56",
          "basis-60",
          "basis-64",
          "basis-72",
          "basis-80",
          "basis-96",
          "basis-auto",
          "basis-px",
          "basis-0.5",
          "basis-1.5",
          "basis-2.5",
          "basis-3.5",
          "basis-1/2",
          "basis-1/3",
          "basis-2/3",
          "basis-1/4",
          "basis-2/4",
          "basis-3/4",
          "basis-1/5",
          "basis-2/5",
          "basis-3/5",
          "basis-4/5",
          "basis-1/6",
          "basis-2/6",
          "basis-3/6",
          "basis-4/6",
          "basis-5/6",
          "basis-1/12",
          "basis-2/12",
          "basis-3/12",
          "basis-4/12",
          "basis-5/12",
          "basis-6/12",
          "basis-7/12",
          "basis-8/12",
          "basis-9/12",
          "basis-10/12",
          "basis-11/12",
          "basis-full"
        ], [:hover, :media_queries]},
       {"flex-direction", "Flex Direction",
        "Utilities for controlling the direction of flex items.",
        [
          "flex-row",
          "flex-row-reverse",
          "flex-col",
          "flex-col-reverse"
        ], [:hover, :media_queries]},
       {"flex-wrap", "Flex Wrap", "Utilities for controlling how flex items wrap.",
        [
          "flex-wrap",
          "flex-wrap-reverse",
          "flex-nowrap"
        ], [:hover, :media_queries]},
       {"flex", "Flex", "Utilities for controlling how flex items both grow and shrink.",
        [
          "flex-1",
          "flex-auto",
          "flex-initial",
          "flex-none"
        ], [:hover, :media_queries]},
       {"flex-grow", "Flex Grow", "Utilities for controlling how flex items grow.",
        [
          "grow",
          "grow-0"
        ], [:hover, :media_queries]},
       {"flex-shrink", "Flex Shrink", "Utilities for controlling how flex items shrink.",
        [
          "shrink",
          "shrink-0"
        ], [:hover, :media_queries]},
       {"order", "Order", "Utilities for controlling the order of flex and grid items.",
        [
          "order-1",
          "order-2",
          "order-3",
          "order-4",
          "order-5",
          "order-6",
          "order-7",
          "order-8",
          "order-9",
          "order-10",
          "order-11",
          "order-12",
          "order-first",
          "order-last",
          "order-none"
        ], [:hover, :media_queries]},
       {"grid-template-columns", "Grid Template Columns",
        "Utilities for specifying the columns in a grid layout.",
        [
          "grid-cols-1",
          "grid-cols-2",
          "grid-cols-3",
          "grid-cols-4",
          "grid-cols-5",
          "grid-cols-6",
          "grid-cols-7",
          "grid-cols-8",
          "grid-cols-9",
          "grid-cols-10",
          "grid-cols-11",
          "grid-cols-12",
          "grid-cols-none"
        ], [:hover, :media_queries]},
       {"grid-column", "Grid Column Start / End",
        "Utilities for controlling how elements are sized and placed across grid columns.",
        [
          "col-auto",
          "col-span-1",
          "col-span-2",
          "col-span-3",
          "col-span-4",
          "col-span-5",
          "col-span-6",
          "col-span-7",
          "col-span-8",
          "col-span-9",
          "col-span-10",
          "col-span-11",
          "col-span-12",
          "col-span-full",
          "col-start-1",
          "col-start-2",
          "col-start-3",
          "col-start-4",
          "col-start-5",
          "col-start-6",
          "col-start-7",
          "col-start-8",
          "col-start-9",
          "col-start-10",
          "col-start-11",
          "col-start-12",
          "col-start-13",
          "col-start-auto",
          "col-end-1",
          "col-end-2",
          "col-end-3",
          "col-end-4",
          "col-end-5",
          "col-end-6",
          "col-end-7",
          "col-end-8",
          "col-end-9",
          "col-end-10",
          "col-end-11",
          "col-end-12",
          "col-end-13",
          "col-end-auto"
        ], [:hover, :media_queries]},
       {"grid-template-rows", "Grid Template Rows",
        "Utilities for specifying the rows in a grid layout.",
        [
          "grid-rows-1",
          "grid-rows-2",
          "grid-rows-3",
          "grid-rows-4",
          "grid-rows-5",
          "grid-rows-6",
          "grid-rows-none"
        ], [:hover, :media_queries]},
       {"grid-template-rows", "Grid Template Rows",
        "Utilities for specifying the rows in a grid layout.",
        [
          "grid-rows-1",
          "grid-rows-2",
          "grid-rows-3",
          "grid-rows-4",
          "grid-rows-5",
          "grid-rows-6",
          "grid-rows-none"
        ], [:hover, :media_queries]},
       {"grid-row", "Grid Row Start / End",
        "Utilities for controlling how elements are sized and placed across grid rows.",
        [
          "row-auto",
          "row-span-1",
          "row-span-2",
          "row-span-3",
          "row-span-4",
          "row-span-5",
          "row-span-6",
          "row-span-full",
          "row-start-1",
          "row-start-2",
          "row-start-3",
          "row-start-4",
          "row-start-5",
          "row-start-6",
          "row-start-7",
          "row-start-auto",
          "row-end-1",
          "row-end-2",
          "row-end-3",
          "row-end-4",
          "row-end-5",
          "row-end-6",
          "row-end-7",
          "row-end-auto"
        ], [:hover, :media_queries]},
       {"grid-auto-flow", "Grid Auto Flow",
        "Utilities for controlling how elements in a grid are auto-placed.",
        [
          "grid-flow-row",
          "grid-flow-col",
          "grid-flow-dense",
          "grid-flow-row-dense",
          "grid-flow-col-dense"
        ], [:hover, :media_queries]},
       {"grid-auto-columns", "Grid Auto Columns",
        "Utilities for controlling the size of implicitly-created grid columns.",
        [
          "auto-cols-auto",
          "auto-cols-min",
          "auto-cols-max",
          "auto-cols-fr"
        ], [:hover, :media_queries]},
       {"grid-auto-rows", "Grid Auto Rows",
        "Utilities for controlling the size of implicitly-created grid rows.",
        [
          "auto-rows-auto",
          "auto-rows-min",
          "auto-rows-max",
          "auto-rows-fr"
        ], [:hover, :media_queries]},
       {"gap", "Gap", "Utilities for controlling gutters between grid and flexbox items.",
        [
          "gap-0",
          "gap-x-0",
          "gap-y-0",
          "gap-px",
          "gap-x-px",
          "gap-y-px",
          "gap-0.5",
          "gap-x-0.5",
          "gap-y-0.5",
          "gap-1",
          "gap-x-1",
          "gap-y-1",
          "gap-1.5",
          "gap-x-1.5",
          "gap-y-1.5",
          "gap-2",
          "gap-x-2",
          "gap-y-2",
          "gap-2.5",
          "gap-x-2.5",
          "gap-y-2.5",
          "gap-3",
          "gap-x-3",
          "gap-y-3",
          "gap-3.5",
          "gap-x-3.5",
          "gap-y-3.5",
          "gap-4",
          "gap-x-4",
          "gap-y-4",
          "gap-5",
          "gap-x-5",
          "gap-y-5",
          "gap-6",
          "gap-x-6",
          "gap-y-6",
          "gap-7",
          "gap-x-7",
          "gap-y-7",
          "gap-8",
          "gap-x-8",
          "gap-y-8",
          "gap-9",
          "gap-x-9",
          "gap-y-9",
          "gap-10",
          "gap-x-10",
          "gap-y-10",
          "gap-11",
          "gap-x-11",
          "gap-y-11",
          "gap-12",
          "gap-x-12",
          "gap-y-12",
          "gap-14",
          "gap-x-14",
          "gap-y-14",
          "gap-16",
          "gap-x-16",
          "gap-y-16",
          "gap-20",
          "gap-x-20",
          "gap-y-20",
          "gap-24",
          "gap-x-24",
          "gap-y-24",
          "gap-28",
          "gap-x-28",
          "gap-y-28",
          "gap-32",
          "gap-x-32",
          "gap-y-32",
          "gap-36",
          "gap-x-36",
          "gap-y-36",
          "gap-40",
          "gap-x-40",
          "gap-y-40",
          "gap-44",
          "gap-x-44",
          "gap-y-44",
          "gap-48",
          "gap-x-48",
          "gap-y-48",
          "gap-52",
          "gap-x-52",
          "gap-y-52",
          "gap-56",
          "gap-x-56",
          "gap-y-56",
          "gap-60",
          "gap-x-60",
          "gap-y-60",
          "gap-64",
          "gap-x-64",
          "gap-y-64",
          "gap-72",
          "gap-x-72",
          "gap-y-72",
          "gap-80",
          "gap-x-80",
          "gap-y-80",
          "gap-96",
          "gap-x-96",
          "gap-y-96"
        ], [:hover, :media_queries]},
       {"justify-content", "Justify Content",
        "Utilities for controlling how flex and grid items are positioned along a container's main axis.",
        [
          "justify-start",
          "justify-end",
          "justify-center",
          "justify-between",
          "justify-around",
          "justify-evenly"
        ], [:hover, :media_queries]},
       {"justify-items", "Justify Items",
        "Utilities for controlling how grid items are aligned along their inline axis.",
        [
          "justify-items-start",
          "justify-items-end",
          "justify-items-center",
          "justify-items-stretch"
        ], [:hover, :media_queries]},
       {"justify-self", "Justify Self",
        "Utilities for controlling how an individual grid item is aligned along its inline axis.",
        [
          "justify-self-auto",
          "justify-self-start",
          "justify-self-end",
          "justify-self-center",
          "justify-self-stretch"
        ], [:hover, :media_queries]},
       {"align-content", "Align Content",
        "Utilities for controlling how rows are positioned in multi-row flex and grid containers.",
        [
          "content-center",
          "content-start",
          "content-end",
          "content-between",
          "content-around",
          "content-evenly",
          "content-baseline"
        ], [:hover, :media_queries]},
       {"align-items", "Align Items",
        "Utilities for controlling how flex and grid items are positioned along a container's cross axis.",
        [
          "items-start",
          "items-end",
          "items-center",
          "items-baseline",
          "items-stretch"
        ], [:hover, :media_queries]},
       {"align-self", "Align Self",
        "Utilities for controlling how an individual flex or grid item is positioned along its container's cross axis.",
        [
          "self-auto",
          "self-start",
          "self-end",
          "self-center",
          "self-stretch",
          "self-baseline"
        ], [:hover, :media_queries]},
       {"place-content", "Place Content",
        "Utilities for controlling how content is justified and aligned at the same time.",
        [
          "place-content-center",
          "place-content-start",
          "place-content-end",
          "place-content-between",
          "place-content-around",
          "place-content-evenly",
          "place-content-baseline",
          "place-content-stretch"
        ], [:hover, :media_queries]},
       {"place-items", "Place Items",
        "Utilities for controlling how items are justified and aligned at the same time.",
        [
          "place-items-start",
          "place-items-end",
          "place-items-center",
          "place-items-baseline",
          "place-items-stretch"
        ], [:hover, :media_queries]},
       {"place-self", "Place Self",
        "Utilities for controlling how an individual item is justified and aligned at the same time.",
        [
          "place-self-auto",
          "place-self-start",
          "place-self-end",
          "place-self-center",
          "place-self-stretch"
        ], [:hover, :media_queries]}
     ]},
    {"spacing", "Spacing", "Heroicons.square_3_stack_3d", []},
    {"sizing", "Sizing", "Heroicons.swatch", []},
    {"typography", "Typography", "Heroicons.chat_bubble_bottom_center", []},
    {"backgrounds", "Backgrounds", "Heroicons.window", []},
    {"borders", "Borders", "Heroicons.bars_2", []},
    {"effects", "Effects", "Heroicons.light_bulb", []},
    {"filters", "Filters", "Heroicons.scissors", []},
    {"tables", "Tables", "Heroicons.table_cells", []},
    {"transitions_animation", "Transitions & Animation", "Heroicons.sparkles", []},
    {"transforms", "Transforms", "Heroicons.rectangle_stack", []},
    {"interactivity", "Interactivity", "Heroicons.paper_clip", []},
    {"accessibility", "Accessibility", "Heroicons.eye", []},
    {"svg", "SVG", "Heroicons.photo", []}
  ]

  @tailwind_section_settings [
    {"layout", "Layout", "Heroicons.inbox_stack", []},
    {"flexbox_grid", "Flexbox & Grid", "Heroicons.circle_stack", []},
    {"spacing", "Spacing", "Heroicons.square_3_stack_3d", []},
    {"sizing", "Sizing", "Heroicons.swatch", []},
    {"typography", "Typography", "Heroicons.chat_bubble_bottom_center", []},
    {"backgrounds", "Backgrounds", "Heroicons.window", []},
    {"borders", "Borders", "Heroicons.bars_2", []},
    {"effects", "Effects", "Heroicons.light_bulb", []},
    {"filters", "Filters", "Heroicons.scissors", []},
    {"tables", "Tables", "Heroicons.table_cells", []},
    {"transitions_animation", "Transitions & Animation", "Heroicons.sparkles", []},
    {"transforms", "Transforms", "Heroicons.rectangle_stack", []},
    {"interactivity", "Interactivity", "Heroicons.paper_clip", []},
    {"accessibility", "Accessibility", "Heroicons.eye", []}
  ]

  attr :block_id, :string, required: true
  attr :type, :string, required: false, default: "layout"
  attr :selected_setting, :map, required: false, default: nil
  attr :custom_class, :string, required: false, default: "layout-icons"
  attr :on_click, JS, default: %JS{}

  @spec block_settings(map) :: Phoenix.LiveView.Rendered.t()
  def block_settings(%{type: type} = assigns) do
    assigns =
      assign(
        assigns,
        :tailwind_settings,
        if(type == "layout", do: @tailwind_layout_settings, else: @tailwind_section_settings)
      )

    ~H"""
    <Heroicons.wrench_screwdriver
      class={@custom_class}
      phx-click={show_modal("#{@type}-settings-#{@block_id}")}
    />
    <.push_modal id={"#{@type}-settings-#{@block_id}"}>
      <%= if is_nil(@selected_setting) do %>
        <p class="text-center font-bold mb-4 text-lg">Please select the section you want to edit</p>
        <div class="grid grid-cols-2 gap-3 text-gray-500 mt-8 mb-10 md:grid-cols-4 lg:grid-cols-5">
          <ElementMenu.block_menu
            :for={{id, title, module, _settings} <- @tailwind_settings}
            id={id}
            title={title}
            phx-click="selected_setting"
            phx-value-id={id}
            phx-value-type={@type}
            phx-value-block-id={@block_id}
          >
            <%= Phoenix.LiveView.HTMLEngine.component(
              Code.eval_string("&#{module}/1") |> elem(0),
              [class: "w-6 h-6 mx-auto stroke-current"],
              {__ENV__.module, __ENV__.function, __ENV__.file, __ENV__.line}
            ) %>
          </ElementMenu.block_menu>
        </div>
        <p
          class="text-center text-sm text-blue-400"
          phx-click="add_custom_class"
          phx-value-id={@block_id}
          phx-value-type={@type}
        >
          <span>OR put your custom classes</span>
        </p>
      <% else %>
        <div class="flex flex-col mx-auto w-full">
          <p class="text-center font-bold text-2xl text-gray-500 mb-6">
            You can change the default setting of
            <code class="bg-pink-400 text-white font-normal p-1 rounded-md text-sm text-center">
              <%= get_setting_title(@tailwind_settings, @selected_setting) %>
            </code>
          </p>

          <div class="flex flex-row gap-2 text-center mx-auto mb-3">
            <.button
              phx-click="reset_settings"
              class="w-24 !bg-white border border-gray-300 shadow-sm text-black hover:bg-gray-400 hover:text-gray-400"
            >
              <div class="flex flex-row text-center gap-2">
                <span>Back</span>
                <Heroicons.arrow_long_left class="w-6 h-6 stroke-current" />
              </div>
            </.button>

            <.button
              phx-click="reset_settings"
              class="!bg-white border border-gray-300 shadow-sm text-black hover:bg-gray-400 hover:text-gray-400"
            >
              <div class="flex flex-row text-center gap-2">
                <span>Reset to default</span>
                <Heroicons.arrow_path class="w-6 h-6 stroke-current" />
              </div>
            </.button>
          </div>
          <hr />
          <.get_form selected_setting={@selected_setting} />
        </div>
      <% end %>
    </.push_modal>
    """
  end

  attr :selected_setting, :map, required: true

  @spec get_form(map) :: Phoenix.LiveView.Rendered.t()
  def get_form(assigns) do
    ~H"""
    <.simple_form
      :let={f}
      for={%{}}
      as={:setting_form}
      phx-submit="save_setting"
      phx-change="validate_setting"
      class="z-40"
    >
      <.input field={f[:setting_form]} label="Tag Name" />
      <:actions>
        <.button class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 disabled:bg-gray-400 disabled:text-white disabled:outline-none">
          Save
        </.button>
      </:actions>
    </.simple_form>
    """
  end

  @spec get_setting_title(list(map), map) :: any
  def get_setting_title(settings, selected_setting) do
    Enum.find(settings, fn {id, _title, _des, _settings} ->
      Map.get(selected_setting, "id") == id
    end)
    |> elem(1)
  rescue
    _e -> ""
  end

  def create_form(_id) do
  end

  def aggregate_form_data_in_favor_of_tailwind(_form_data) do
  end
end
