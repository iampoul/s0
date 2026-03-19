import SwiftUI

// MARK: - S0 Table

extension S0 {
    public struct Table<Row: Identifiable>: View {
        private let columns: [TableColumn]
        private let rows: [Row]
        private let valueProvider: (Row, String) -> String
        @State private var sortColumn: String?
        @State private var sortAscending: Bool = true

        public init(
            columns: [TableColumn],
            rows: [Row],
            valueProvider: @escaping (Row, String) -> String
        ) {
            self.columns = columns
            self.rows = rows
            self.valueProvider = valueProvider
        }

        public var body: some View {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 0) {
                    ForEach(columns) { column in
                        Button {
                            if sortColumn == column.id {
                                sortAscending.toggle()
                            } else {
                                sortColumn = column.id
                                sortAscending = true
                            }
                        } label: {
                            HStack(spacing: S0.Theme.Spacing.xs) {
                                Text(column.title)
                                    .font(S0.Theme.Typography.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(S0.Theme.Colors.mutedForeground)
                                if sortColumn == column.id {
                                    Image(systemName: sortAscending ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 10))
                                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: column.alignment)
                            .padding(.horizontal, S0.Theme.Spacing.md)
                            .padding(.vertical, S0.Theme.Spacing.sm)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .background(S0.Theme.Colors.muted.opacity(0.5))

                S0.Separator()

                // Rows
                ForEach(sortedRows) { row in
                    HStack(spacing: 0) {
                        ForEach(columns) { column in
                            Text(valueProvider(row, column.id))
                                .font(S0.Theme.Typography.body)
                                .foregroundColor(S0.Theme.Colors.foreground)
                                .frame(maxWidth: .infinity, alignment: column.alignment)
                                .padding(.horizontal, S0.Theme.Spacing.md)
                                .padding(.vertical, S0.Theme.Spacing.sm)
                        }
                    }

                    S0.Separator()
                }
            }
            .background(S0.Theme.Colors.background)
            .cornerRadius(S0.Theme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                    .stroke(S0.Theme.Colors.border, lineWidth: 1)
            )
        }

        private var sortedRows: [Row] {
            guard let sortColumn else { return rows }
            return rows.sorted { a, b in
                let aVal = valueProvider(a, sortColumn)
                let bVal = valueProvider(b, sortColumn)
                return sortAscending ? aVal < bVal : aVal > bVal
            }
        }
    }

    public struct TableColumn: Identifiable {
        public let id: String
        public let title: String
        public let alignment: Alignment

        public init(id: String, title: String, alignment: Alignment = .leading) {
            self.id = id
            self.title = title
            self.alignment = alignment
        }
    }
}
