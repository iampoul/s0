export interface ComponentDoc {
  name: string
  slug: string
  description: string
  category: "primitives" | "forms" | "layout"
  usage: string[]
  props: { name: string; type: string; default?: string; description: string }[]
}

export const categories = {
  primitives: "Primitives",
  forms: "Forms",
  layout: "Layout",
} as const

export const components: ComponentDoc[] = [
  // ── Primitives ──────────────────────────────────────────────────────
  {
    name: "Button",
    slug: "button",
    description: "A customizable button component with multiple variants.",
    category: "primitives",
    usage: [
      `S0.Button("Save", action: { print("Tapped") })`,
      `S0.Button("Delete", variant: .destructive, size: .lg, action: {
    // handle delete
})`,
      `S0.Button(variant: .outline, size: .icon, action: { }) {
    Image(systemName: "heart")
}`,
    ],
    props: [
      { name: "title", type: "String", description: "Button label text (convenience initializer)." },
      { name: "variant", type: "ButtonVariant", default: ".default", description: "Visual style: .default, .secondary, .destructive, .outline, .ghost, .link." },
      { name: "size", type: "ButtonSize", default: ".default", description: "Size preset: .default (40pt), .sm (36pt), .lg (44pt), .icon (40×40)." },
      { name: "action", type: "() -> Void", description: "Closure invoked on tap." },
      { name: "label", type: "@ViewBuilder () -> Label", description: "Custom label view (generic initializer)." },
    ],
  },
  {
    name: "Badge",
    slug: "badge",
    description: "A small label for status, counts, or categories.",
    category: "primitives",
    usage: [
      `S0.Badge("New")`,
      `S0.Badge("Archived", variant: .secondary)`,
      `S0.Badge("Error", variant: .destructive)`,
      `S0.Badge("Draft", variant: .outline)`,
    ],
    props: [
      { name: "text", type: "String", description: "The badge label." },
      { name: "variant", type: "BadgeVariant", default: ".default", description: "Visual style: .default, .secondary, .destructive, .outline." },
    ],
  },
  {
    name: "Toggle",
    slug: "toggle",
    description: "A styled switch control with an optional label.",
    category: "primitives",
    usage: [
      `@State private var isOn = false

S0.Toggle("Airplane Mode", isOn: $isOn)`,
      `S0.Toggle(isOn: $isEnabled)`,
    ],
    props: [
      { name: "label", type: "String?", default: "nil", description: "Optional text label displayed next to the switch." },
      { name: "isOn", type: "Binding<Bool>", description: "Binding to the toggle state." },
    ],
  },
  {
    name: "Separator",
    slug: "separator",
    description: "A horizontal or vertical divider line.",
    category: "primitives",
    usage: [
      `S0.Separator()`,
      `S0.Separator(.vertical)`,
      `VStack {
    Text("Above")
    S0.Separator()
    Text("Below")
}`,
    ],
    props: [
      { name: "orientation", type: "SeparatorOrientation", default: ".horizontal", description: "Direction: .horizontal or .vertical." },
    ],
  },
  {
    name: "Avatar",
    slug: "avatar",
    description: "A circular image with fallback initials.",
    category: "primitives",
    usage: [
      `S0.Avatar(initials: "JD")`,
      `S0.Avatar(image: Image("profile"), size: .lg)`,
      `S0.Avatar(initials: "AB", size: .sm)`,
    ],
    props: [
      { name: "image", type: "Image?", default: "nil", description: "An optional SwiftUI Image to display." },
      { name: "initials", type: "String", default: '""', description: "Fallback initials (max 2 characters)." },
      { name: "size", type: "AvatarSize", default: ".default", description: "Size preset: .sm (32pt), .default (40pt), .lg (56pt)." },
    ],
  },
  {
    name: "Progress",
    slug: "progress",
    description: "A determinate progress bar.",
    category: "primitives",
    usage: [
      `S0.Progress(value: 0.6)`,
      `@State private var progress = 0.3

S0.Progress(value: progress)`,
    ],
    props: [
      { name: "value", type: "Double", description: "Progress from 0.0 to 1.0. Clamped automatically." },
    ],
  },
  {
    name: "Spinner",
    slug: "spinner",
    description: "An indeterminate loading indicator.",
    category: "primitives",
    usage: [
      `S0.Spinner()`,
      `S0.Spinner(size: 32, lineWidth: 3)`,
    ],
    props: [
      { name: "size", type: "CGFloat", default: "20", description: "Diameter of the spinner." },
      { name: "lineWidth", type: "CGFloat", default: "2", description: "Stroke width of the arc." },
    ],
  },
  {
    name: "Skeleton",
    slug: "skeleton",
    description: "A placeholder shimmer for loading states.",
    category: "primitives",
    usage: [
      `S0.Skeleton(height: 20)`,
      `S0.Skeleton(width: 100, height: 16)`,
      `VStack(alignment: .leading, spacing: 8) {
    S0.Skeleton(width: 200, height: 20)
    S0.Skeleton(height: 14)
    S0.Skeleton(height: 14)
}`,
    ],
    props: [
      { name: "width", type: "CGFloat?", default: "nil", description: "Fixed width. Full-width when nil." },
      { name: "height", type: "CGFloat", default: "20", description: "Height of the skeleton rectangle." },
    ],
  },

  // ── Layout ──────────────────────────────────────────────────────────
  {
    name: "Card",
    slug: "card",
    description: "A container for content with header, body, and footer sections.",
    category: "layout",
    usage: [
      `S0.Card {
    S0.CardHeader {
        S0.CardTitle("Account")
        S0.CardDescription("Manage your account settings.")
    }
    S0.CardContent {
        Text("Card body content goes here.")
    }
    S0.CardFooter {
        S0.Button("Save", action: { })
    }
}`,
    ],
    props: [
      { name: "content", type: "@ViewBuilder () -> Content", description: "Card body. Use CardHeader, CardContent, and CardFooter inside." },
    ],
  },
  {
    name: "Tabs",
    slug: "tabs",
    description: "Segmented tab navigation with trigger and content panels.",
    category: "layout",
    usage: [
      `@State private var tab = 0

S0.Tabs {
    S0.TabList {
        S0.TabTrigger("Account", isSelected: tab == 0) { tab = 0 }
        S0.TabTrigger("Settings", isSelected: tab == 1) { tab = 1 }
    }
    S0.TabContent {
        if tab == 0 {
            Text("Account content")
        } else {
            Text("Settings content")
        }
    }
}`,
    ],
    props: [
      { name: "content", type: "@ViewBuilder () -> Content", description: "Wrap TabList and TabContent inside." },
    ],
  },
  {
    name: "Alert",
    slug: "alert",
    description: "An inline alert banner with icon and variant styling.",
    category: "layout",
    usage: [
      `S0.Alert {
    S0.AlertTitle("Heads up!")
    S0.AlertDescription("You can add components using the CLI.")
}`,
      `S0.Alert(variant: .destructive) {
    S0.AlertTitle("Error")
    S0.AlertDescription("Something went wrong.")
}`,
    ],
    props: [
      { name: "variant", type: "AlertVariant", default: ".default", description: "Style: .default, .destructive, .success, .warning." },
      { name: "content", type: "@ViewBuilder () -> Content", description: "Use AlertTitle and AlertDescription inside." },
    ],
  },
  {
    name: "Sheet",
    slug: "sheet",
    description: "A bottom sheet modal with drag indicator and detents.",
    category: "layout",
    usage: [
      `@State private var showSheet = false

Button("Open Sheet") { showSheet = true }
    .s0Sheet(isPresented: $showSheet) {
        Text("Sheet content")
    }`,
    ],
    props: [
      { name: "isPresented", type: "Binding<Bool>", description: "Controls sheet visibility." },
      { name: "content", type: "@ViewBuilder () -> SheetContent", description: "Content displayed inside the sheet." },
    ],
  },
  {
    name: "Accordion",
    slug: "accordion",
    description: "Collapsible content sections with animated expand/collapse.",
    category: "layout",
    usage: [
      `S0.Accordion("Is it accessible?") {
    Text("Yes. Built on native SwiftUI disclosure.")
}`,
      `S0.Accordion("Open by default", expanded: true) {
    Text("This section starts expanded.")
}`,
    ],
    props: [
      { name: "title", type: "String", description: "Header text for the accordion trigger." },
      { name: "expanded", type: "Bool", default: "false", description: "Initial expanded state." },
      { name: "content", type: "@ViewBuilder () -> Content", description: "Collapsible body content." },
    ],
  },
  {
    name: "DropdownMenu",
    slug: "dropdown-menu",
    description: "A contextual menu with items, icons, and destructive actions.",
    category: "layout",
    usage: [
      `S0.DropdownMenu(items: [
    .item("Edit", icon: "pencil") { },
    .item("Duplicate", icon: "doc.on.doc") { },
    .divider,
    .destructive("Delete", icon: "trash") { },
]) {
    S0.Button("Options", variant: .outline, action: { })
}`,
    ],
    props: [
      { name: "items", type: "[DropdownItem]", description: "Array of menu items. Use .item(), .destructive(), or .divider." },
      { name: "label", type: "@ViewBuilder () -> Label", description: "Trigger view for the menu." },
    ],
  },
  {
    name: "Popover",
    slug: "popover",
    description: "A floating content panel triggered by a button.",
    category: "layout",
    usage: [
      `S0.Popover {
    Text("Click me")
} content: {
    Text("Popover content here")
        .frame(width: 200)
}`,
    ],
    props: [
      { name: "label", type: "@ViewBuilder () -> Label", description: "Trigger view." },
      { name: "content", type: "@ViewBuilder () -> Content", description: "Content displayed inside the popover." },
    ],
  },
  {
    name: "Toast",
    slug: "toast",
    description: "A non-blocking notification with auto-dismiss.",
    category: "layout",
    usage: [
      `@State private var showToast = false

S0.Toast("Changes saved!", isPresented: $showToast)`,
      `S0.Toast("Something went wrong",
    variant: .destructive,
    isPresented: $showError)`,
    ],
    props: [
      { name: "message", type: "String", description: "Notification text." },
      { name: "variant", type: "ToastVariant", default: ".default", description: "Style: .default, .success, .destructive, .warning." },
      { name: "isPresented", type: "Binding<Bool>", description: "Controls toast visibility. Auto-dismisses after 3s." },
    ],
  },

  // ── Forms ───────────────────────────────────────────────────────────
  {
    name: "Input",
    slug: "input",
    description: "A styled text input field with optional label support.",
    category: "forms",
    usage: [
      `@State private var email = ""

S0.Input("Email", text: $email, placeholder: "you@example.com")`,
      `S0.Input(text: $name, placeholder: "Enter your name")`,
    ],
    props: [
      { name: "label", type: "String?", default: "nil", description: "Optional label displayed above the field." },
      { name: "text", type: "Binding<String>", description: "Binding to the text value." },
      { name: "placeholder", type: "String", default: '""', description: "Placeholder text." },
    ],
  },
  {
    name: "Checkbox",
    slug: "checkbox",
    description: "A toggleable checkmark with an optional label.",
    category: "forms",
    usage: [
      `@State private var agreed = false

S0.Checkbox("I agree to the terms", isChecked: $agreed)`,
      `S0.Checkbox(isChecked: $isSelected)`,
    ],
    props: [
      { name: "label", type: "String?", default: "nil", description: "Optional label next to the checkbox." },
      { name: "isChecked", type: "Binding<Bool>", description: "Binding to the checked state." },
    ],
  },
  {
    name: "RadioGroup",
    slug: "radio-group",
    description: "A single-select group of radio buttons.",
    category: "forms",
    usage: [
      `@State private var plan = "free"

S0.RadioGroup(selection: $plan, options: [
    (value: "free", label: "Free"),
    (value: "pro", label: "Pro"),
    (value: "enterprise", label: "Enterprise"),
])`,
    ],
    props: [
      { name: "selection", type: "Binding<Value>", description: "Binding to the selected value." },
      { name: "options", type: "[(value: Value, label: String)]", description: "Array of value-label pairs." },
    ],
  },
  {
    name: "Select",
    slug: "select",
    description: "A dropdown picker with optional label.",
    category: "forms",
    usage: [
      `@State private var fruit = "apple"

S0.Select("Fruit", selection: $fruit, options: [
    (value: "apple", label: "Apple"),
    (value: "banana", label: "Banana"),
    (value: "cherry", label: "Cherry"),
])`,
    ],
    props: [
      { name: "label", type: "String?", default: "nil", description: "Optional label above the picker." },
      { name: "selection", type: "Binding<Value>", description: "Binding to the selected value." },
      { name: "options", type: "[(value: Value, label: String)]", description: "Array of value-label pairs." },
    ],
  },
  {
    name: "Slider",
    slug: "slider",
    description: "A range input with track and thumb.",
    category: "forms",
    usage: [
      `@State private var volume = 0.5

S0.Slider("Volume", value: $volume)`,
      `S0.Slider("Brightness", value: $brightness, in: 0...100, step: 5)`,
    ],
    props: [
      { name: "label", type: "String?", default: "nil", description: "Optional label above the slider." },
      { name: "value", type: "Binding<Double>", description: "Binding to the current value." },
      { name: "range", type: "ClosedRange<Double>", default: "0...1", description: "Allowed value range." },
      { name: "step", type: "Double?", default: "nil", description: "Step increment. Continuous when nil." },
    ],
  },
  {
    name: "Stepper",
    slug: "stepper",
    description: "An increment/decrement control with label.",
    category: "forms",
    usage: [
      `@State private var quantity = 1

S0.Stepper("Quantity", value: $quantity, in: 0...10)`,
    ],
    props: [
      { name: "label", type: "String?", default: "nil", description: "Optional label next to the value." },
      { name: "value", type: "Binding<Int>", description: "Binding to the integer value." },
      { name: "range", type: "ClosedRange<Int>", default: "0...100", description: "Allowed value range." },
    ],
  },
  {
    name: "TextArea",
    slug: "textarea",
    description: "A multi-line text input field.",
    category: "forms",
    usage: [
      `@State private var bio = ""

S0.TextArea("Bio", text: $bio, placeholder: "Tell us about yourself")`,
      `S0.TextArea(text: $notes, placeholder: "Notes...", minHeight: 120)`,
    ],
    props: [
      { name: "label", type: "String?", default: "nil", description: "Optional label above the text area." },
      { name: "text", type: "Binding<String>", description: "Binding to the text value." },
      { name: "placeholder", type: "String", default: '""', description: "Placeholder text." },
      { name: "minHeight", type: "CGFloat", default: "80", description: "Minimum height of the text area." },
    ],
  },
  {
    name: "Label",
    slug: "label",
    description: "A form field label with optional required indicator.",
    category: "forms",
    usage: [
      `S0.Label("Email")`,
      `S0.Label("Password", required: true)`,
    ],
    props: [
      { name: "text", type: "String", description: "Label text." },
      { name: "required", type: "Bool", default: "false", description: 'Shows a red asterisk "*" when true.' },
    ],
  },

  // ── New Components ──────────────────────────────────────────────────
  {
    name: "Table",
    slug: "table",
    description: "A data table with sortable columns and rows.",
    category: "layout",
    usage: [
      `S0.Table(columns: [
    S0.TableColumn("Name", keyPath: \\.name),
    S0.TableColumn("Email", keyPath: \\.email),
], rows: users)`,
      `S0.Table(columns: [
    S0.TableColumn("Name", keyPath: \\.name, sortable: true),
    S0.TableColumn("Age", keyPath: \\.age, sortable: true),
], rows: people, valueProvider: { row, col in
    "\\(row[keyPath: col])"
})`,
    ],
    props: [
      { name: "columns", type: "[TableColumn]", description: "Array of column definitions." },
      { name: "rows", type: "[Row]", description: "Array of row data." },
      { name: "valueProvider", type: "(Row, String) -> String", description: "Closure that returns the display string for a given row and column key." },
    ],
  },
  {
    name: "SearchBar",
    slug: "search-bar",
    description: "Styled search input with clear button and submit action.",
    category: "forms",
    usage: [
      `@State private var query = ""

S0.SearchBar(text: $query)`,
      `S0.SearchBar(text: $query, placeholder: "Find a recipe…") {
    performSearch()
}`,
    ],
    props: [
      { name: "text", type: "Binding<String>", description: "Binding to the search text." },
      { name: "placeholder", type: "String", default: '"Search..."', description: "Placeholder text displayed when empty." },
      { name: "onSubmit", type: "(() -> Void)?", default: "nil", description: "Closure invoked when the user submits the search." },
    ],
  },
  {
    name: "Dialog",
    slug: "dialog",
    description: "Modal dialog with title, description, and action buttons.",
    category: "layout",
    usage: [
      `@State private var showDialog = false

S0.Dialog(isPresented: $showDialog, title: "Confirm Deletion") {
    S0.Button("Delete", variant: .destructive, action: { })
    S0.Button("Cancel", variant: .outline, action: { showDialog = false })
}`,
      `Button("Show Dialog") { showDialog = true }
    .s0Dialog(isPresented: $showDialog, title: "Are you sure?", description: "This action cannot be undone.") {
        S0.Button("Confirm", action: { })
    }`,
    ],
    props: [
      { name: "isPresented", type: "Binding<Bool>", description: "Controls dialog visibility." },
      { name: "title", type: "String", description: "Dialog title text." },
      { name: "description", type: "String?", default: "nil", description: "Optional description text below the title." },
    ],
  },
  {
    name: "DatePicker",
    slug: "date-picker",
    description: "Date picker with graphical, compact, and field variants. Supports validation, presets, optional dates, and date range selection.",
    category: "forms",
    usage: [
      `@State private var date = Date()

// Graphical calendar (default)
S0.DatePicker("Birthday", selection: $date)`,
      `// Compact inline row
S0.DatePicker("Reminder", selection: $date, variant: .compact)`,
      `// Field variant — tap to reveal calendar
S0.DatePicker("Due date", selection: $date, variant: .field)`,
      `// With date constraints
S0.DatePicker("Appointment", selection: $date, in: Date()...Date().addingTimeInterval(90 * 86400))`,
      `// With validation
S0.DatePicker("Start date", selection: $date, validation: .error("Must be in the future"))`,
      `// With presets
S0.DatePicker("Deadline", selection: $date, presets: [.today, .tomorrow, .nextWeek, .nextMonth])`,
      `// Optional date with placeholder and clear button
@State private var optionalDate: Date? = nil

S0.OptionalDatePicker("Expiry date", selection: $optionalDate, placeholder: "No expiry set")`,
      `// Date range picker with presets
@State private var start = Date()
@State private var end = Date()

S0.DateRangePicker("Trip dates", start: $start, end: $end, presets: [.thisWeek, .thisMonth, .last30Days])`,
    ],
    props: [
      { name: "label", type: "String?", default: "nil", description: "Optional label displayed above the picker." },
      { name: "selection", type: "Binding<Date>", description: "Binding to the selected date." },
      { name: "variant", type: "DatePickerVariant", default: ".graphical", description: "Display style: .graphical (calendar), .compact (inline row), .field (tap-to-reveal)." },
      { name: "displayedComponents", type: "DatePicker.Components", default: "[.date]", description: "What to display: .date, .hourAndMinute, or both." },
      { name: "in", type: "ClosedRange<Date>?", default: "nil", description: "Optional min/max date constraint." },
      { name: "validation", type: "DatePickerValidation", default: ".none", description: "Validation state: .none, .error(\"message\"), .success(\"message\")." },
      { name: "presets", type: "[DatePreset]", default: "[]", description: "Quick-select preset buttons: .today, .tomorrow, .nextWeek, .nextMonth, or custom." },
    ],
  },
  {
    name: "NavigationBar",
    slug: "navigation-bar",
    description: "Custom navigation header with title, subtitle, and action slots.",
    category: "layout",
    usage: [
      `S0.NavigationBar(title: "Settings")`,
      `S0.NavigationBar(title: "Profile", subtitle: "Edit your info") {
    S0.Button(variant: .ghost, size: .icon, action: { goBack() }) {
        Image(systemName: "chevron.left")
    }
} trailing: {
    S0.Button(variant: .ghost, size: .icon, action: { }) {
        Image(systemName: "gearshape")
    }
}`,
    ],
    props: [
      { name: "title", type: "String", description: "Primary title text." },
      { name: "subtitle", type: "String?", default: "nil", description: "Optional subtitle below the title." },
      { name: "leading", type: "@ViewBuilder () -> Leading", description: "View displayed on the leading (left) side." },
      { name: "trailing", type: "@ViewBuilder () -> Trailing", description: "View displayed on the trailing (right) side." },
    ],
  },
  {
    name: "SegmentedControl",
    slug: "segmented-control",
    description: "Horizontal segment picker for switching between options.",
    category: "forms",
    usage: [
      `@State private var view = "list"

S0.SegmentedControl(selection: $view, options: [
    (value: "list", label: "List"),
    (value: "grid", label: "Grid"),
    (value: "map", label: "Map"),
])`,
    ],
    props: [
      { name: "selection", type: "Binding<Value>", description: "Binding to the currently selected value." },
      { name: "options", type: "[(value: Value, label: String)]", description: "Array of value-label pairs for each segment." },
    ],
  },
  {
    name: "Tooltip",
    slug: "tooltip",
    description: "Floating hint on hover or long-press.",
    category: "layout",
    usage: [
      `S0.Button("Save", action: { })
    .s0Tooltip("Save your changes")`,
      `Image(systemName: "info.circle")
    .s0Tooltip("More information", edge: .bottom)`,
    ],
    props: [
      { name: "message", type: "String", description: "Tooltip text to display." },
      { name: "edge", type: "TooltipEdge", default: ".top", description: "Preferred edge for placement: .top, .bottom, .leading, .trailing." },
    ],
  },
  {
    name: "ScrollArea",
    slug: "scroll-area",
    description: "Styled scrollable container with configurable axes.",
    category: "layout",
    usage: [
      `S0.ScrollArea(maxHeight: 300) {
    VStack {
        ForEach(items) { item in
            Text(item.name)
        }
    }
}`,
      `S0.ScrollArea(axis: .horizontal, showsIndicators: false) {
    HStack(spacing: 12) {
        ForEach(images) { img in
            Image(img.name)
        }
    }
}`,
    ],
    props: [
      { name: "axis", type: "ScrollAreaAxis", default: ".vertical", description: "Scroll direction: .vertical, .horizontal, .both." },
      { name: "showsIndicators", type: "Bool", default: "true", description: "Whether to show scroll indicators." },
      { name: "maxHeight", type: "CGFloat?", default: "nil", description: "Optional maximum height for the scroll area." },
    ],
  },
]

export function getComponentBySlug(slug: string): ComponentDoc | undefined {
  return components.find((c) => c.slug === slug)
}

export function getComponentsByCategory(category: ComponentDoc["category"]): ComponentDoc[] {
  return components.filter((c) => c.category === category)
}

export const sidebarNav = {
  gettingStarted: [
    { title: "Introduction", href: "/docs" },
    { title: "Getting Started", href: "/docs/getting-started" },
    { title: "Theming", href: "/docs/theming" },
  ],
  components: {
    primitives: getComponentsByCategory("primitives").map((c) => ({
      title: c.name,
      href: `/docs/components/${c.slug}`,
    })),
    forms: getComponentsByCategory("forms").map((c) => ({
      title: c.name,
      href: `/docs/components/${c.slug}`,
    })),
    layout: getComponentsByCategory("layout").map((c) => ({
      title: c.name,
      href: `/docs/components/${c.slug}`,
    })),
  },
}
