import XCTest
import SwiftUI
import SnapshotTesting

#if canImport(AppKit)
import AppKit
#endif

@testable import S0ShowcaseLib

final class ComponentSnapshotTests: XCTestCase {

    override func invokeTest() {
        isRecording = true
        super.invokeTest()
    }

    private func snapshotView<V: View>(
        _ view: V,
        named name: String,
        size: CGSize = CGSize(width: 400, height: 200)
    ) {
        #if canImport(AppKit)
        let themed = view
            .padding(S0.Theme.Spacing.lg)
            .background(S0.Theme.Colors.background)
            .frame(width: size.width, height: size.height)

        let hostingView = NSHostingView(rootView: themed)
        hostingView.frame = CGRect(origin: .zero, size: size)
        assertSnapshot(of: hostingView, as: .image, named: name)
        #endif
    }

    // MARK: - 1. Button

    func testButton() {
        snapshotView(
            VStack(spacing: S0.Theme.Spacing.sm) {
                HStack(spacing: S0.Theme.Spacing.sm) {
                    S0.Button("Default", action: {})
                    S0.Button("Secondary", variant: .secondary, action: {})
                    S0.Button("Destructive", variant: .destructive, action: {})
                }
                HStack(spacing: S0.Theme.Spacing.sm) {
                    S0.Button("Outline", variant: .outline, action: {})
                    S0.Button("Ghost", variant: .ghost, action: {})
                    S0.Button("Link", variant: .link, action: {})
                }
            },
            named: "button",
            size: CGSize(width: 500, height: 150)
        )
    }

    // MARK: - 2. Badge

    func testBadge() {
        snapshotView(
            HStack(spacing: S0.Theme.Spacing.sm) {
                S0.Badge("Default")
                S0.Badge("Secondary", variant: .secondary)
                S0.Badge("Destructive", variant: .destructive)
                S0.Badge("Outline", variant: .outline)
            },
            named: "badge",
            size: CGSize(width: 450, height: 80)
        )
    }

    // MARK: - 3. Card

    func testCard() {
        snapshotView(
            S0.Card {
                S0.CardHeader {
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs) {
                        S0.CardTitle("Card Title")
                        S0.CardDescription("Card description goes here.")
                    }
                }
                S0.CardContent {
                    Text("This is the card body content.")
                }
                S0.CardFooter {
                    S0.Button("Action", variant: .outline, action: {})
                }
            },
            named: "card",
            size: CGSize(width: 400, height: 250)
        )
    }

    // MARK: - 4. Input

    func testInput() {
        snapshotView(
            VStack(spacing: S0.Theme.Spacing.sm) {
                S0.Input("Email", text: .constant("hello@example.com"), placeholder: "Enter email")
                S0.Input(text: .constant(""), placeholder: "Empty input")
            },
            named: "input",
            size: CGSize(width: 400, height: 160)
        )
    }

    // MARK: - 5. TextArea

    func testTextArea() {
        snapshotView(
            S0.TextArea("Description", text: .constant("Some example text content here."), placeholder: "Enter text"),
            named: "textarea",
            size: CGSize(width: 400, height: 200)
        )
    }

    // MARK: - 6. Toggle

    func testToggle() {
        snapshotView(
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.sm) {
                S0.Toggle("Enabled", isOn: .constant(true))
                S0.Toggle("Disabled", isOn: .constant(false))
            },
            named: "toggle",
            size: CGSize(width: 300, height: 120)
        )
    }

    // MARK: - 7. Checkbox

    func testCheckbox() {
        snapshotView(
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.sm) {
                S0.Checkbox("Checked item", isChecked: .constant(true))
                S0.Checkbox("Unchecked item", isChecked: .constant(false))
            },
            named: "checkbox",
            size: CGSize(width: 300, height: 120)
        )
    }

    // MARK: - 8. Slider

    func testSlider() {
        snapshotView(
            VStack(spacing: S0.Theme.Spacing.sm) {
                S0.Slider("Volume", value: .constant(0.6))
                S0.Slider(value: .constant(0.3))
            },
            named: "slider",
            size: CGSize(width: 400, height: 130)
        )
    }

    // MARK: - 9. Stepper

    func testStepper() {
        snapshotView(
            S0.Stepper("Count", value: .constant(5), in: 0...10),
            named: "stepper",
            size: CGSize(width: 300, height: 100)
        )
    }

    // MARK: - 10. Progress

    func testProgress() {
        snapshotView(
            VStack(spacing: S0.Theme.Spacing.md) {
                S0.Progress(value: 0.7)
                S0.Progress(value: 0.3)
            },
            named: "progress",
            size: CGSize(width: 400, height: 100)
        )
    }

    // MARK: - 11. Spinner

    func testSpinner() {
        snapshotView(
            HStack(spacing: S0.Theme.Spacing.lg) {
                S0.Spinner()
                S0.Spinner(size: 32, lineWidth: 3)
            },
            named: "spinner",
            size: CGSize(width: 200, height: 100)
        )
    }

    // MARK: - 12. Skeleton

    func testSkeleton() {
        snapshotView(
            VStack(spacing: S0.Theme.Spacing.sm) {
                S0.Skeleton(height: 20)
                S0.Skeleton(height: 20)
                S0.Skeleton(width: 200, height: 20)
                S0.Skeleton(height: 100)
            },
            named: "skeleton",
            size: CGSize(width: 400, height: 230)
        )
    }

    // MARK: - 13. Alert

    func testAlert() {
        snapshotView(
            VStack(spacing: S0.Theme.Spacing.sm) {
                S0.Alert(variant: .default) {
                    S0.AlertTitle("Heads up!")
                    S0.AlertDescription("This is a default alert message.")
                }
                S0.Alert(variant: .destructive) {
                    S0.AlertTitle("Error")
                    S0.AlertDescription("Something went wrong.")
                }
            },
            named: "alert",
            size: CGSize(width: 450, height: 250)
        )
    }

    // MARK: - 14. Avatar

    func testAvatar() {
        snapshotView(
            HStack(spacing: S0.Theme.Spacing.md) {
                S0.Avatar(initials: "S0", size: .sm)
                S0.Avatar(initials: "AB", size: .default)
                S0.Avatar(initials: "XY", size: .lg)
            },
            named: "avatar",
            size: CGSize(width: 300, height: 120)
        )
    }

    // MARK: - 15. Label

    func testLabel() {
        snapshotView(
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.sm) {
                S0.Label("Username")
                S0.Label("Email", required: true)
            },
            named: "label",
            size: CGSize(width: 300, height: 100)
        )
    }

    // MARK: - 16. Separator

    func testSeparator() {
        snapshotView(
            VStack(spacing: S0.Theme.Spacing.md) {
                Text("Above")
                S0.Separator()
                Text("Below")
            },
            named: "separator",
            size: CGSize(width: 300, height: 120)
        )
    }

    // MARK: - 17. Accordion

    func testAccordion() {
        snapshotView(
            VStack(spacing: 0) {
                S0.Accordion("Section 1", expanded: true) {
                    Text("Content for section 1.")
                }
                S0.Accordion("Section 2") {
                    Text("Content for section 2.")
                }
                S0.Accordion("Section 3") {
                    Text("Content for section 3.")
                }
            },
            named: "accordion",
            size: CGSize(width: 400, height: 250)
        )
    }

    // MARK: - 18. Tabs

    func testTabs() {
        snapshotView(
            S0.Tabs {
                S0.TabList {
                    S0.TabTrigger("Tab 1", isSelected: true, action: {})
                    S0.TabTrigger("Tab 2", isSelected: false, action: {})
                    S0.TabTrigger("Tab 3", isSelected: false, action: {})
                }
                S0.TabContent {
                    Text("Content for Tab 1")
                        .padding(S0.Theme.Spacing.md)
                }
            },
            named: "tabs",
            size: CGSize(width: 450, height: 180)
        )
    }

    // MARK: - 19. Select

    func testSelect() {
        snapshotView(
            S0.Select(
                "Fruit",
                selection: .constant("apple"),
                options: [
                    (value: "apple", label: "Apple"),
                    (value: "banana", label: "Banana"),
                    (value: "cherry", label: "Cherry"),
                ]
            ),
            named: "select",
            size: CGSize(width: 300, height: 120)
        )
    }

    // MARK: - 20. RadioGroup

    func testRadioGroup() {
        snapshotView(
            S0.RadioGroup(
                selection: .constant("A"),
                options: [
                    (value: "A", label: "Option A"),
                    (value: "B", label: "Option B"),
                    (value: "C", label: "Option C"),
                ]
            ),
            named: "radiogroup",
            size: CGSize(width: 300, height: 170)
        )
    }

    // MARK: - 21. DropdownMenu

    func testDropdownMenu() {
        snapshotView(
            S0.DropdownMenu("Actions", items: [
                .item("Edit", icon: "pencil", action: {}),
                .item("Duplicate", icon: "doc.on.doc", action: {}),
                .divider,
                .destructive("Delete", icon: "trash", action: {}),
            ]),
            named: "dropdownmenu",
            size: CGSize(width: 300, height: 100)
        )
    }

    // MARK: - 22. Popover

    func testPopover() {
        snapshotView(
            S0.Popover {
                S0.Button("Open Popover", action: {})
            } content: {
                Text("Popover content")
                    .padding(S0.Theme.Spacing.md)
            },
            named: "popover",
            size: CGSize(width: 300, height: 100)
        )
    }

    // MARK: - 23. Sheet

    func testSheet() {
        snapshotView(
            S0.Button("Open Sheet", action: {})
                .s0Sheet(isPresented: .constant(false)) {
                    Text("Sheet content")
                },
            named: "sheet",
            size: CGSize(width: 300, height: 100)
        )
    }

    // MARK: - 24. Dialog

    func testDialog() {
        snapshotView(
            S0.Button("Open Dialog", action: {})
                .s0Dialog(isPresented: .constant(false), title: "Dialog Title", description: "A dialog description.") {
                    EmptyView()
                },
            named: "dialog",
            size: CGSize(width: 300, height: 100)
        )
    }

    // MARK: - 25. Toast

    func testToast() {
        snapshotView(
            VStack(spacing: S0.Theme.Spacing.sm) {
                S0.Toast("Action completed", isPresented: .constant(true))
                S0.Toast("Something went wrong", variant: .destructive, isPresented: .constant(true))
            },
            named: "toast",
            size: CGSize(width: 400, height: 160)
        )
    }

    // MARK: - 26. Tooltip

    func testTooltip() {
        snapshotView(
            S0.Button("Hover me", action: {})
                .s0Tooltip("Tooltip text"),
            named: "tooltip",
            size: CGSize(width: 300, height: 100)
        )
    }

    // MARK: - 27. Table

    func testTable() {
        struct TableRow: Identifiable {
            let id: String
            let name: String
            let status: String
            let role: String
        }

        let columns = [
            S0.TableColumn(id: "name", title: "Name"),
            S0.TableColumn(id: "status", title: "Status"),
            S0.TableColumn(id: "role", title: "Role"),
        ]

        let rows = [
            TableRow(id: "1", name: "Alice", status: "Active", role: "Admin"),
            TableRow(id: "2", name: "Bob", status: "Inactive", role: "User"),
            TableRow(id: "3", name: "Carol", status: "Active", role: "Editor"),
        ]

        snapshotView(
            S0.Table(columns: columns, rows: rows) { row, columnID in
                switch columnID {
                case "name": return row.name
                case "status": return row.status
                case "role": return row.role
                default: return ""
                }
            },
            named: "table",
            size: CGSize(width: 500, height: 220)
        )
    }

    // MARK: - 28. SearchBar

    func testSearchBar() {
        snapshotView(
            S0.SearchBar(text: .constant("Search query"), placeholder: "Search..."),
            named: "searchbar",
            size: CGSize(width: 400, height: 100)
        )
    }

    // MARK: - 29. DatePicker

    func testDatePicker() {
        snapshotView(
            S0.DatePicker("Date", selection: .constant(Date(timeIntervalSince1970: 1_700_000_000))),
            named: "datepicker",
            size: CGSize(width: 350, height: 120)
        )
    }

    // MARK: - 30. NavigationBar

    func testNavigationBar() {
        snapshotView(
            S0.NavigationBar(title: "Page Title", subtitle: "Subtitle text"),
            named: "navigationbar",
            size: CGSize(width: 500, height: 100)
        )
    }

    // MARK: - 31. SegmentedControl

    func testSegmentedControl() {
        snapshotView(
            S0.SegmentedControl(
                selection: .constant("first"),
                options: [
                    (value: "first", label: "First"),
                    (value: "second", label: "Second"),
                    (value: "third", label: "Third"),
                ]
            ),
            named: "segmentedcontrol",
            size: CGSize(width: 400, height: 100)
        )
    }

    // MARK: - 32. ScrollArea

    func testScrollArea() {
        snapshotView(
            S0.ScrollArea(maxHeight: 150) {
                VStack(alignment: .leading, spacing: S0.Theme.Spacing.sm) {
                    ForEach(0..<10, id: \.self) { i in
                        Text("Item \(i)")
                            .padding(S0.Theme.Spacing.sm)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            },
            named: "scrollarea",
            size: CGSize(width: 300, height: 200)
        )
    }
}
