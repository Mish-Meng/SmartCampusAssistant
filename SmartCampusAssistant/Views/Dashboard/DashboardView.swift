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

            Group {
                switch viewModel.selectedTab {
                case .dashboard:
                    dashboardWithBottomNav
                case .calendar:
                    ScheduleView()
                case .settings:
                    SettingsPlaceholderView(onSignOut: authViewModel.signOut)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var dashboardWithBottomNav: some View {
        VStack(spacing: 0) {
            Group {
                switch viewModel.selectedMenuItem {
                case .standupTasks:
                    StandupTasksView(viewModel: viewModel)
                case .taskBreakdown:
                    TaskBreakdownView()
                case .campusChat:
                    CampusChatSectionView()
                case .assignments:
                    AssignmentsView()
                case .joinClass:
                    JoinClassView()
                case .integrations:
                    IntegrationsView()
                }
            }
            .frame(maxHeight: .infinity)

            DashboardMenuBottomNav(selectedItem: $viewModel.selectedMenuItem)
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
                    .foregroundStyle(.primary)
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "bell")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

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
        HStack(spacing: 8) {
            ForEach(DashboardTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    Text(tab.rawValue)
                        .font(.subheadline)
                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                        .foregroundStyle(selectedTab == tab ? AppTheme.purple : .secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            selectedTab == tab
                                ? AppTheme.purple.opacity(0.1)
                                : Color.clear
                        )
                        .clipShape(Capsule())
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
        .overlay(alignment: .bottom) {
            Divider()
        }
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
                Image(systemName: "plus")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(10)
                    .foregroundStyle(.white)
                    .background(AppTheme.primaryGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
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
