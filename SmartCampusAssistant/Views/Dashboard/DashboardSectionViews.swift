import SwiftUI

struct TaskBreakdownView: View {
    var body: some View {
        DashboardSectionPlaceholder(
            title: "Task Breakdown",
            icon: "chart.bar.xaxis",
            description: "View your tasks organized by course, priority, and deadline."
        )
    }
}

struct CampusChatSectionView: View {
    var body: some View {
        AssistantView()
    }
}

struct AssignmentsView: View {
    var body: some View {
        DashboardSectionPlaceholder(
            title: "Assignments",
            icon: "book.closed",
            description: "Track upcoming assignments, due dates, and submission status."
        )
    }
}

struct JoinClassView: View {
    var body: some View {
        DashboardSectionPlaceholder(
            title: "Join Class",
            icon: "video.fill",
            description: "Join live lectures and virtual classroom sessions."
        )
    }
}

struct IntegrationsView: View {
    var body: some View {
        DashboardSectionPlaceholder(
            title: "Integrations",
            icon: "point.3.connected.trianglepath.dotted",
            description: "Connect Google Calendar, Moodle, and other campus tools."
        )
    }
}

struct DashboardSectionPlaceholder: View {
    let title: String
    let icon: String
    let description: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.purple.opacity(0.6))

            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}
