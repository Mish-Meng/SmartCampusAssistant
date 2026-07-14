import SwiftUI

struct DiningView: View {
    @StateObject private var viewModel = DiningViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.locations) { location in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(location.name)
                            .font(.headline)

                        Spacer()

                        StatusBadge(isOpen: location.isOpen)
                    }

                    Label(location.building, systemImage: "building.2")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(location.hours)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.campusGreen)

                    if !location.menuHighlights.isEmpty {
                        Text(location.menuHighlights.joined(separator: " · "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Dining")
        }
    }
}

struct StatusBadge: View {
    let isOpen: Bool

    var body: some View {
        Text(isOpen ? "Open" : "Closed")
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isOpen ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
            .foregroundStyle(isOpen ? .green : .red)
            .clipShape(Capsule())
    }
}

#Preview {
    DiningView()
}
