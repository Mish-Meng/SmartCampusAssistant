import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        VStack(spacing: 0) {
            DashboardHeaderView(
                userName: authViewModel.displayName,
                userEmail: authViewModel.displayEmail,
                onSignOut: authViewModel.signOut
            )

            DashboardTabBar(selectedTab: $viewModel.selectedTab)

            switch viewModel.selectedTab {
            case .dashboard:
                dashboardContent
            case .calendar:
                ScheduleView()
            case .settings:
                SettingsPlaceholderView(onSignOut: authViewModel.signOut)
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
    }

    private var dashboardContent: some View {
        VStack(spacing: 0) {
            DashboardMenuBar(selectedItem: $viewModel.selectedMenuItem)

            DashboardToolbar(searchText: $viewModel.searchText)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(viewModel.filteredColumns) { column in
                        TaskColumnView(column: column)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }

            AIAssistantBanner()
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
        }
    }
}

// MARK: - Header

struct DashboardHeaderView: View {
    let userName: String
    let userEmail: String
    let onSignOut: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                AppLogoView(size: 32)
                Text("Smart Campus")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(userName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(userEmail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Menu {
                Button("Sign Out", role: .destructive, action: onSignOut)
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .font(.title2)
                    .foregroundStyle(AppTheme.purple)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

// MARK: - Tab Bar

struct DashboardTabBar: View {
    @Binding var selectedTab: DashboardTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(DashboardTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    Text(tab.rawValue)
                        .font(.subheadline)
                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                        .foregroundStyle(selectedTab == tab ? AppTheme.purple : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(alignment: .bottom) {
                            if selectedTab == tab {
                                Rectangle()
                                    .fill(AppTheme.purple)
                                    .frame(height: 2)
                            }
                        }
                }
            }
        }
        .background(Color.white)
    }
}

// MARK: - Sidebar Menu

struct DashboardMenuBar: View {
    @Binding var selectedItem: DashboardMenuItem

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(DashboardMenuItem.allCases) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: item.icon)
                                .font(.caption)
                            Text(item.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedItem == item ? AppTheme.purple.opacity(0.12) : Color.white)
                        .foregroundStyle(selectedItem == item ? AppTheme.purple : .primary)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(selectedItem == item ? AppTheme.purple.opacity(0.3) : Color(.systemGray4), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.white)
    }
}

// MARK: - Toolbar

struct DashboardToolbar: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search tasks...", text: $searchText)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )

            Button {
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "line.3.horizontal.decrease")
                    Text("Filter")
                }
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            .foregroundStyle(.primary)

            Button {
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "plus")
                    Text("New Task")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .foregroundStyle(.white)
                .background(AppTheme.primaryGradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

// MARK: - Kanban Column

struct TaskColumnView: View {
    let column: TaskColumn

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(column.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("(\(column.count))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if column.tasks.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(.systemGray4), style: StrokeStyle(lineWidth: 1, dash: [6]))
                    .frame(width: 220, height: 120)
                    .overlay {
                        Image(systemName: "plus")
                            .foregroundStyle(.secondary)
                    }
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(column.tasks) { task in
                            LectureTaskCard(task: task)
                        }
                    }
                }
                .frame(width: 220)
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

struct LectureTaskCard: View {
    let task: LectureTask

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("LECTURE")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(task.priority.rawValue)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(priorityColor.opacity(0.15))
                    .foregroundStyle(priorityColor)
                    .clipShape(Capsule())
            }

            Text(task.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)

            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption2)
                Text(task.time)
                    .font(.caption)
            }
            .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.caption2)
                Text(task.location)
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color(red: 0.98, green: 0.98, blue: 0.99))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    private var priorityColor: Color {
        switch task.priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

// MARK: - AI Banner

struct AIAssistantBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.title3)
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 4) {
                Text("AI ASSISTANT")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.9))

                Text("Ask me \"Where is my next class?\" for instant directions!")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(14)
        .background(AppTheme.primaryGradient)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Settings Placeholder

struct SettingsPlaceholderView: View {
    let onSignOut: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "gearshape.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.purple.opacity(0.5))

            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Account and app preferences coming soon.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button("Sign Out", role: .destructive, action: onSignOut)
                .buttonStyle(.bordered)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel())
}
