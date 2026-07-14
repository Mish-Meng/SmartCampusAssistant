import SwiftUI

struct CampusMapView: View {
    @StateObject private var viewModel = CampusMapViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.filteredBuildings) { building in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(building.name)
                            .font(.headline)

                        Text(building.category.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(building.abbreviation)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.campusGreen.opacity(0.15))
                        .foregroundStyle(AppTheme.campusGreen)
                        .clipShape(Capsule())
                }
            }
            .navigationTitle("Campus Map")
            .searchable(text: $viewModel.searchText, prompt: "Search buildings")
            .overlay {
                if viewModel.filteredBuildings.isEmpty {
                    ContentUnavailableView(
                        "No buildings found",
                        systemImage: "building.2",
                        description: Text("Try a different search term.")
                    )
                }
            }
        }
    }
}

#Preview {
    CampusMapView()
}
