import SwiftUI

// MARK: - S0 DatePicker

extension S0 {

    // MARK: - Types

    public enum DatePickerVariant {
        case graphical
        case compact
        case field
    }

    public enum DatePickerValidation: Equatable {
        case none
        case error(String)
        case success(String?)
    }

    public struct DatePreset: Identifiable {
        public let id = UUID()
        public let label: String
        public let date: Date

        public init(_ label: String, date: Date) {
            self.label = label
            self.date = date
        }

        public static var today: DatePreset {
            DatePreset("Today", date: Calendar.current.startOfDay(for: Date()))
        }

        public static var tomorrow: DatePreset {
            let d = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!
            return DatePreset("Tomorrow", date: d)
        }

        public static var nextWeek: DatePreset {
            let d = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Calendar.current.startOfDay(for: Date()))!
            return DatePreset("Next Week", date: d)
        }

        public static var nextMonth: DatePreset {
            let d = Calendar.current.date(byAdding: .month, value: 1, to: Calendar.current.startOfDay(for: Date()))!
            return DatePreset("Next Month", date: d)
        }
    }

    public struct DateRangePreset: Identifiable {
        public let id = UUID()
        public let label: String
        public let start: Date
        public let end: Date

        public init(_ label: String, start: Date, end: Date) {
            self.label = label
            self.start = start
            self.end = end
        }

        public static var thisWeek: DateRangePreset {
            let cal = Calendar.current
            let interval = cal.dateInterval(of: .weekOfYear, for: Date())!
            let end = cal.date(byAdding: .day, value: 6, to: interval.start)!
            return DateRangePreset("This Week", start: interval.start, end: end)
        }

        public static var thisMonth: DateRangePreset {
            let cal = Calendar.current
            let interval = cal.dateInterval(of: .month, for: Date())!
            let end = cal.date(byAdding: DateComponents(month: 1, day: -1), to: interval.start)!
            return DateRangePreset("This Month", start: interval.start, end: end)
        }

        public static var last7Days: DateRangePreset {
            let cal = Calendar.current
            let today = cal.startOfDay(for: Date())
            let start = cal.date(byAdding: .day, value: -6, to: today)!
            return DateRangePreset("Last 7 Days", start: start, end: today)
        }

        public static var last30Days: DateRangePreset {
            let cal = Calendar.current
            let today = cal.startOfDay(for: Date())
            let start = cal.date(byAdding: .day, value: -29, to: today)!
            return DateRangePreset("Last 30 Days", start: start, end: today)
        }
    }

    // MARK: - DatePicker

    public struct DatePicker: View {
        private let label: String?
        @Binding private var selection: Date
        private let variant: DatePickerVariant
        private let displayedComponents: SwiftUI.DatePicker.Components
        private let range: ClosedRange<Date>?
        private let validation: DatePickerValidation
        private let presets: [DatePreset]

        @State private var showingFieldPicker = false
        @Environment(\.accessibilityReduceMotion) private var reduceMotion

        public init(
            _ label: String? = nil,
            selection: Binding<Date>,
            variant: DatePickerVariant = .graphical,
            displayedComponents: SwiftUI.DatePicker.Components = [.date],
            in range: ClosedRange<Date>? = nil,
            validation: DatePickerValidation = .none,
            presets: [DatePreset] = []
        ) {
            self.label = label
            self._selection = selection
            self.variant = variant
            self.displayedComponents = displayedComponents
            self.range = range
            self.validation = validation
            self.presets = presets
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs) {
                if let label {
                    Text(label)
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                        .accessibilityHidden(true)
                }

                if !presets.isEmpty {
                    presetsBar
                }

                switch variant {
                case .graphical:
                    graphicalVariant
                case .compact:
                    compactVariant
                case .field:
                    fieldVariant
                }

                validationMessage
            }
            .accessibilityElement(children: .contain)
        }

        // MARK: - Presets

        private var presetsBar: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: S0.Theme.Spacing.xs) {
                    ForEach(presets) { preset in
                        let isActive = Calendar.current.isDate(selection, inSameDayAs: preset.date)
                        Button {
                            withAnimation(reduceMotion ? nil : S0.Theme.Animation.fast) {
                                selection = preset.date
                            }
                        } label: {
                            Text(preset.label)
                                .font(S0.Theme.Typography.caption)
                                .foregroundColor(isActive ? S0.Theme.Colors.primaryForeground : S0.Theme.Colors.foreground)
                                .padding(.horizontal, S0.Theme.Spacing.sm)
                                .padding(.vertical, S0.Theme.Spacing.xs)
                                .background(isActive ? S0.Theme.Colors.primary : S0.Theme.Colors.muted)
                                .cornerRadius(S0.Theme.Radius.full)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(preset.label)
                        .accessibilityAddTraits(isActive ? .isSelected : [])
                    }
                }
            }
        }

        // MARK: - Graphical

        private var graphicalVariant: some View {
            nativePicker
                .datePickerStyle(.graphical)
                .accessibilityLabel(label ?? "Date picker")
                .padding(S0.Theme.Spacing.md)
                .background(S0.Theme.Colors.background)
                .cornerRadius(S0.Theme.Radius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                        .stroke(borderColor, lineWidth: 1)
                )
                .accessibilityLabel(label ?? "Date")
                .accessibilityValue(formattedDate)
        }

        // MARK: - Compact

        private var compactVariant: some View {
            HStack {
                if let label {
                    Text(label)
                        .font(S0.Theme.Typography.body)
                        .foregroundColor(S0.Theme.Colors.foreground)
                }

                Spacer()

                nativePicker
                    #if os(iOS)
                    .datePickerStyle(.compact)
                    #else
                    .datePickerStyle(.field)
                    #endif
            }
            .padding(.horizontal, S0.Theme.Spacing.md)
            .padding(.vertical, S0.Theme.Spacing.sm)
            .background(S0.Theme.Colors.background)
            .cornerRadius(S0.Theme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                    .stroke(borderColor, lineWidth: 1)
            )
        }

        // MARK: - Field

        private var fieldVariant: some View {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    withAnimation(reduceMotion ? nil : S0.Theme.Animation.default) {
                        showingFieldPicker.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(S0.Theme.Colors.mutedForeground)
                            .accessibilityHidden(true)
                        Text(formattedDate)
                            .font(S0.Theme.Typography.body)
                            .foregroundColor(S0.Theme.Colors.foreground)
                        Spacer()
                        Image(systemName: showingFieldPicker ? "chevron.up" : "chevron.down")
                            .font(S0.Theme.Typography.caption)
                            .foregroundColor(S0.Theme.Colors.mutedForeground)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, S0.Theme.Spacing.md)
                    .padding(.vertical, S0.Theme.Spacing.sm + S0.Theme.Spacing.xxs)
                    .background(S0.Theme.Colors.background)
                    .cornerRadius(S0.Theme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                            .stroke(borderColor, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(label ?? "Date")
                .accessibilityValue(formattedDate)
                .accessibilityHint("Double tap to \(showingFieldPicker ? "close" : "open") date picker")
                .accessibilityAddTraits(.isButton)

                if showingFieldPicker {
                    nativePicker
                        .datePickerStyle(.graphical)
                        .padding(S0.Theme.Spacing.sm)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }

        // MARK: - Shared

        private var nativePicker: some View {
            Group {
                if let range {
                    SwiftUI.DatePicker("", selection: $selection, in: range, displayedComponents: displayedComponents)
                } else {
                    SwiftUI.DatePicker("", selection: $selection, displayedComponents: displayedComponents)
                }
            }
            .labelsHidden()
        }

        @ViewBuilder
        private var validationMessage: some View {
            switch validation {
            case .none:
                EmptyView()
            case .error(let message):
                SwiftUI.Label(message, systemImage: "exclamationmark.circle.fill")
                    .font(S0.Theme.Typography.caption)
                    .foregroundColor(S0.Theme.Colors.destructive)
                    .accessibilityLabel("Error: \(message)")
            case .success(let message):
                if let message {
                    SwiftUI.Label(message, systemImage: "checkmark.circle.fill")
                        .font(S0.Theme.Typography.caption)
                        .foregroundColor(S0.Theme.Colors.success)
                        .accessibilityLabel(message)
                }
            }
        }

        private var borderColor: Color {
            switch validation {
            case .none: return S0.Theme.Colors.border
            case .error: return S0.Theme.Colors.destructive
            case .success: return S0.Theme.Colors.success
            }
        }

        private var formattedDate: String {
            let formatter = DateFormatter()
            if displayedComponents.contains(.date) && displayedComponents.contains(.hourAndMinute) {
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
            } else if displayedComponents.contains(.hourAndMinute) {
                formatter.dateStyle = .none
                formatter.timeStyle = .short
            } else {
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
            }
            return formatter.string(from: selection)
        }
    }

    // MARK: - OptionalDatePicker

    public struct OptionalDatePicker: View {
        private let label: String?
        @Binding private var selection: Date?
        private let variant: DatePickerVariant
        private let displayedComponents: SwiftUI.DatePicker.Components
        private let range: ClosedRange<Date>?
        private let validation: DatePickerValidation
        private let presets: [DatePreset]
        private let placeholder: String

        @State private var internalDate: Date
        @State private var hasSelection: Bool
        @Environment(\.accessibilityReduceMotion) private var reduceMotion

        public init(
            _ label: String? = nil,
            selection: Binding<Date?>,
            variant: DatePickerVariant = .field,
            displayedComponents: SwiftUI.DatePicker.Components = [.date],
            in range: ClosedRange<Date>? = nil,
            validation: DatePickerValidation = .none,
            presets: [DatePreset] = [],
            placeholder: String = "Select a date\u{2026}"
        ) {
            self.label = label
            self._selection = selection
            self.variant = variant
            self.displayedComponents = displayedComponents
            self.range = range
            self.validation = validation
            self.presets = presets
            self.placeholder = placeholder
            self._internalDate = State(initialValue: selection.wrappedValue ?? Date())
            self._hasSelection = State(initialValue: selection.wrappedValue != nil)
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs) {
                if let label {
                    HStack {
                        Text(label)
                            .font(S0.Theme.Typography.button)
                            .foregroundColor(S0.Theme.Colors.mutedForeground)
                        Spacer()
                        if hasSelection {
                            Button {
                                withAnimation(reduceMotion ? nil : S0.Theme.Animation.fast) {
                                    hasSelection = false
                                    selection = nil
                                }
                            } label: {
                                Text("Clear")
                                    .font(S0.Theme.Typography.caption)
                                    .foregroundColor(S0.Theme.Colors.mutedForeground)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Clear date selection")
                        }
                    }
                }

                if hasSelection {
                    S0.DatePicker(
                        selection: Binding(
                            get: { internalDate },
                            set: { newDate in
                                internalDate = newDate
                                selection = newDate
                            }
                        ),
                        variant: variant,
                        displayedComponents: displayedComponents,
                        in: range,
                        validation: validation,
                        presets: presets
                    )
                } else {
                    placeholderView
                }
            }
        }

        private var placeholderView: some View {
            Button {
                withAnimation(reduceMotion ? nil : S0.Theme.Animation.default) {
                    hasSelection = true
                    internalDate = Date()
                    selection = Date()
                }
            } label: {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                        .accessibilityHidden(true)
                    Text(placeholder)
                        .font(S0.Theme.Typography.body)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                    Spacer()
                }
                .padding(.horizontal, S0.Theme.Spacing.md)
                .padding(.vertical, S0.Theme.Spacing.sm + S0.Theme.Spacing.xxs)
                .background(S0.Theme.Colors.background)
                .cornerRadius(S0.Theme.Radius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                        .stroke(borderColor, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(label ?? "Date picker")
            .accessibilityHint("Double tap to select a date")
            .accessibilityAddTraits(.isButton)
        }

        private var borderColor: Color {
            switch validation {
            case .none: return S0.Theme.Colors.border
            case .error: return S0.Theme.Colors.destructive
            case .success: return S0.Theme.Colors.success
            }
        }
    }

    // MARK: - DateRangePicker

    public struct DateRangePicker: View {
        private let label: String?
        @Binding private var start: Date
        @Binding private var end: Date
        private let displayedComponents: SwiftUI.DatePicker.Components
        private let validation: DatePickerValidation
        private let presets: [DateRangePreset]

        @Environment(\.accessibilityReduceMotion) private var reduceMotion

        public init(
            _ label: String? = nil,
            start: Binding<Date>,
            end: Binding<Date>,
            displayedComponents: SwiftUI.DatePicker.Components = [.date],
            validation: DatePickerValidation = .none,
            presets: [DateRangePreset] = []
        ) {
            self.label = label
            self._start = start
            self._end = end
            self.displayedComponents = displayedComponents
            self.validation = validation
            self.presets = presets
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs) {
                if let label {
                    Text(label)
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                        .accessibilityHidden(true)
                }

                if !presets.isEmpty {
                    rangePresetsBar
                }

                HStack(spacing: S0.Theme.Spacing.sm) {
                    S0.DatePicker(
                        "From",
                        selection: Binding(
                            get: { start },
                            set: { newStart in
                                start = newStart
                                if newStart > end { end = newStart }
                            }
                        ),
                        variant: .field,
                        displayedComponents: displayedComponents
                    )

                    Image(systemName: "arrow.right")
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                        .accessibilityHidden(true)

                    S0.DatePicker(
                        "To",
                        selection: Binding(
                            get: { end },
                            set: { newEnd in
                                end = max(newEnd, start)
                            }
                        ),
                        variant: .field,
                        displayedComponents: displayedComponents,
                        in: start...Date.distantFuture
                    )
                }

                rangeValidationMessage
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(label ?? "Date range")
        }

        private var rangePresetsBar: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: S0.Theme.Spacing.xs) {
                    ForEach(presets) { preset in
                        let isActive = Calendar.current.isDate(start, inSameDayAs: preset.start)
                            && Calendar.current.isDate(end, inSameDayAs: preset.end)
                        Button {
                            withAnimation(reduceMotion ? nil : S0.Theme.Animation.fast) {
                                start = preset.start
                                end = preset.end
                            }
                        } label: {
                            Text(preset.label)
                                .font(S0.Theme.Typography.caption)
                                .foregroundColor(isActive ? S0.Theme.Colors.primaryForeground : S0.Theme.Colors.foreground)
                                .padding(.horizontal, S0.Theme.Spacing.sm)
                                .padding(.vertical, S0.Theme.Spacing.xs)
                                .background(isActive ? S0.Theme.Colors.primary : S0.Theme.Colors.muted)
                                .cornerRadius(S0.Theme.Radius.full)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(preset.label)
                        .accessibilityAddTraits(isActive ? .isSelected : [])
                    }
                }
            }
        }

        @ViewBuilder
        private var rangeValidationMessage: some View {
            switch validation {
            case .none:
                EmptyView()
            case .error(let message):
                SwiftUI.Label(message, systemImage: "exclamationmark.circle.fill")
                    .font(S0.Theme.Typography.caption)
                    .foregroundColor(S0.Theme.Colors.destructive)
                    .accessibilityLabel("Error: \(message)")
            case .success(let message):
                if let message {
                    SwiftUI.Label(message, systemImage: "checkmark.circle.fill")
                        .font(S0.Theme.Typography.caption)
                        .foregroundColor(S0.Theme.Colors.success)
                        .accessibilityLabel(message)
                }
            }
        }
    }
}
