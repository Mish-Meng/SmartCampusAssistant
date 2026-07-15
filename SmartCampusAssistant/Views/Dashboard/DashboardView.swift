import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
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
            .background(Color(.systemGroupedBackground))
            .navigationDestination(for: TaskColumnKind.self) { kind in
                TaskCategoryDetailView(
                    kind: kind,
                    tasks: viewModel.tasks(for: kind)
                )
            }
        }
    }

    private var dashboardContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                categoryGrid
                AIAssistantBanner()
            }
            .padding(16)
        }
    }

    private var categoryGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(TaskColumnKind.allCases) { kind in
                NavigationLink(value: kind) {
                    TaskCategoryCard(
                        kind: kind,
                        count: viewModel.count(for: kind)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Category Card

struct TaskCategoryCard: View {
    let kind: TaskColumnKind
    let count: Int

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconBackgroundColor.opacity(0.25))
                    .frame(width: 72, height: 72)

                Image(systemName: kind.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(iconForegroundColor)
            }

            VStack(spacing: 4) {
                Text(kind.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                if count > 0 {
                    Text("\(count) task\(count == 1 ? "" : "s")")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(AppTheme.dashboardCard)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.dashboardCardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.dashboardCardRadius)
                .stroke(AppTheme.dashboardCardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    private var iconForegroundColor: Color {
        switch kind.iconColor {
        case "orange": return .orange
        case "yellow": return .yellow
        case "blue": return .blue
        case "purple": return AppTheme.purple
        case "green": return .green
        default: return .gray
        }
    }

    private var iconBackgroundColor: Color {
        iconForegroundColor
    }
}

// MARK: - Category Detail

struct TaskCategoryDetailView: View {
    let kind: TaskColumnKind
    let tasks: [LectureTask]

    var body: some View {
        Group {
            if tasks.isEmpty {
                ContentUnavailableView(
                    "No tasks yet",
                    systemImage: kind.icon,
                    description: Text("Tasks in \(kind.rawValue) will appear here.")
                )
            } else {
                List(tasks) { task in
                    LectureTaskCard(task: task)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(kind.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
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
                    .foregroundStyle(.primary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(userName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
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
        .overlay(alignment: .bottom) {
            Divider()
        }
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
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

// MARK: - Task Card

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
                .foregroundStyle(.primary)
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
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.dashboardCardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
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
                .foregroundStyle(.primary)

            Text("Account and app preferences coming soon.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button("Sign Out", role: .destructive, action: onSignOut)
                .buttonStyle(.bordered)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel())
}
